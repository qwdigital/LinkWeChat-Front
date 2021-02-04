package com.linkwechat.wecom.service.impl;

import cn.hutool.core.collection.CollectionUtil;
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.linkwechat.common.constant.WeConstans;
import com.linkwechat.common.utils.DateUtils;
import com.linkwechat.common.utils.SecurityUtils;
import com.linkwechat.common.utils.StringUtils;
import com.linkwechat.wecom.client.WeExternalContactClient;
import com.linkwechat.wecom.domain.*;
import com.linkwechat.wecom.domain.dto.WeExternalContactDto;
import com.linkwechat.wecom.domain.dto.WeTaskFissionPosterDTO;
import com.linkwechat.wecom.domain.dto.message.CustomerMessagePushDto;
import com.linkwechat.wecom.domain.dto.message.LinkMessageDto;
import com.linkwechat.wecom.mapper.WeTaskFissionMapper;
import com.linkwechat.wecom.service.*;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * 任务宝Service业务层处理
 *
 * @author leejoker
 * @date 2021-01-20
 */
@Slf4j
@Service
public class WeTaskFissionServiceImpl implements IWeTaskFissionService {
    @Autowired
    private WeTaskFissionMapper weTaskFissionMapper;
    @Autowired
    private IWeTaskFissionStaffService weTaskFissionStaffService;
    @Autowired
    private IWeEmpleCodeService weEmpleCodeService;
    @Autowired
    private IWeCustomerMessagePushService weCustomerMessagePushService;
    @Autowired
    private IWeTaskFissionRecordService weTaskFissionRecordService;
    @Autowired
    private IWeUserService weUserService;
    @Autowired
    private WeExternalContactClient weExternalContactClient;
    @Autowired
    private IWePosterService wePosterService;

    /**
     * 查询任务宝
     *
     * @param id 任务宝ID
     * @return 任务宝
     */
    @Override
    public WeTaskFission selectWeTaskFissionById(Long id) {
        return weTaskFissionMapper.selectWeTaskFissionById(id);
    }

    /**
     * 查询任务宝列表
     *
     * @param weTaskFission 任务宝
     * @return 任务宝
     */
    @Override
    public List<WeTaskFission> selectWeTaskFissionList(WeTaskFission weTaskFission) {
        return weTaskFissionMapper.selectWeTaskFissionList(weTaskFission);
    }

    /**
     * 新增任务宝
     *
     * @param weTaskFission 任务宝
     * @return 结果
     */
    @Override
    @Transactional
    public int insertWeTaskFission(WeTaskFission weTaskFission) {
        weTaskFission.setCreateBy(SecurityUtils.getUsername());
        weTaskFission.setCreateTime(DateUtils.getNowDate());
        int insertResult = weTaskFissionMapper.insertWeTaskFission(weTaskFission);
        if (insertResult > 0) {
            if (CollectionUtils.isNotEmpty(weTaskFission.getTaskFissionStaffs())) {
                if (weTaskFission.getId() != null) {
                    weTaskFission.getTaskFissionStaffs().forEach(staff -> {
                        staff.setTaskFissionId(weTaskFission.getId());
                    });
                    weTaskFissionStaffService.insertWeTaskFissionStaffList(weTaskFission.getTaskFissionStaffs());
                }
            }
        }
        return insertResult;
    }

    /**
     * 修改任务宝
     *
     * @param weTaskFission 任务宝
     * @return 结果
     */
    @Override
    public int updateWeTaskFission(WeTaskFission weTaskFission) {
        weTaskFission.setUpdateTime(DateUtils.getNowDate());
        return weTaskFissionMapper.updateWeTaskFission(weTaskFission);
    }

    /**
     * 批量删除任务宝
     *
     * @param ids 需要删除的任务宝ID
     * @return 结果
     */
    @Override
    public int deleteWeTaskFissionByIds(Long[] ids) {
        return weTaskFissionMapper.deleteWeTaskFissionByIds(ids);
    }

    /**
     * 删除任务宝信息
     *
     * @param id 任务宝ID
     * @return 结果
     */
    @Override
    public int deleteWeTaskFissionById(Long id) {
        return weTaskFissionMapper.deleteWeTaskFissionById(id);
    }


    @Override
    public void sendWeTaskFission(Long id) {
        WeTaskFission weTaskFission = selectWeTaskFissionById(id);
        //海报路径
        String postersPath = weTaskFission.getPostersUrl();
        //目标员工id
        String fissionTargetId = weTaskFission.getFissionTargetId();
        //目标员工活码
        String fissQrcode = weTaskFission.getFissQrcode();
        //todo 生成海报

        LinkMessageDto linkMessageDto = new LinkMessageDto();
        linkMessageDto.setPicurl(postersPath);
        linkMessageDto.setDesc(weTaskFission.getFissInfo());
        linkMessageDto.setTitle(weTaskFission.getTaskName());
        linkMessageDto.setUrl("www.baidu.com");

        CustomerMessagePushDto customerMessagePushDto = new CustomerMessagePushDto();
        customerMessagePushDto.setLinkMessage(linkMessageDto);
        customerMessagePushDto.setPushType("0");
        customerMessagePushDto.setPushRange("1");
        customerMessagePushDto.setMessageType("2");
        customerMessagePushDto.setTag(weTaskFission.getCustomerTagId());
        //查询发起成员
        List<WeTaskFissionStaff> weTaskFissionStaffList = weTaskFissionStaffService.selectWeTaskFissionStaffByTaskId(id);
        if (CollectionUtil.isNotEmpty(weTaskFissionStaffList)) {
            //获取部门id
            String departmentIds = weTaskFissionStaffList.stream().filter(weTaskFissionStaff ->
                    WeConstans.USE_SCOP_BUSINESSID_TYPE_ORG.equals(weTaskFissionStaff.getStaffType()))
                    .map(WeTaskFissionStaff::getStaffId).collect(Collectors.joining(","));
            //获取成员id
            String userIds = weTaskFissionStaffList.stream().filter(weTaskFissionStaff ->
                    WeConstans.USE_SCOP_BUSINESSID_TYPE_USER.equals(weTaskFissionStaff.getStaffType()))
                    .map(WeTaskFissionStaff::getStaffId).collect(Collectors.joining(","));
            customerMessagePushDto.setStaffId(userIds);
            customerMessagePushDto.setDepartment(departmentIds);
        }
        try {
            weCustomerMessagePushService.addWeCustomerMessagePush(customerMessagePushDto);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            log.error("发送任务失败》》》》》》》》》》》params:{},ex:{}", JSONObject.toJSONString(customerMessagePushDto), e);
        }


    }

    @Override
    @Transactional
    public String fissionPosterGenerate(WeTaskFissionPosterDTO weTaskFissionPosterDTO) {
        WeUser user = weUserService.selectWeUserById(weTaskFissionPosterDTO.getUserId());
        if (user != null) {
            WeTaskFissionRecord record = getTaskFissionRecordId(weTaskFissionPosterDTO.getTaskFissionId(), user.getUserId(), user.getName());
            String qrcode = getPosterQRCode(weTaskFissionPosterDTO.getFissStaffId(), record);

            //保存qrcode信息
            WeTaskFission taskFission = weTaskFissionMapper.selectWeTaskFissionById(weTaskFissionPosterDTO.getTaskFissionId());
            taskFission.setFissQrcode(qrcode);
            weTaskFissionMapper.updateWeTaskFission(taskFission);

            WePoster poster = wePosterService.selectOne(weTaskFissionPosterDTO.getPosterId());
            poster.getPosterSubassemblyList().stream().filter(Objects::nonNull)
                    .filter(wePosterSubassembly -> wePosterSubassembly.getType() == 3).forEach(wePosterSubassembly -> {
                wePosterSubassembly.setImgPath(qrcode);
            });
            return wePosterService.generateSimpleImg(poster);
        } else {
            throw new RuntimeException("客户信息不存在");
        }
    }

    private String getPosterQRCode(String fissStaffId, WeTaskFissionRecord record) {
        WeExternalContactDto dto = null;
        if (StringUtils.isNotBlank(record.getConfigId())) {
            dto = weExternalContactClient.getContactWay(record.getConfigId());
        }
        if (dto == null) {
            //获取二维码
            WeExternalContactDto.WeContactWay contactWay = posterContactWay(fissStaffId, record.getId());
            dto = weExternalContactClient.addContactWay(contactWay);
            record.setConfigId(dto.getConfig_id());
            int updateResult = weTaskFissionRecordService.updateWeTaskFissionRecord(record);
            if (updateResult <= 0) {
                throw new RuntimeException("生成海报异常：更新裂变记录失败");
            }
        }
        return dto.getQr_code();
    }

    private WeExternalContactDto.WeContactWay posterContactWay(String fissUserId, Long recordId) {
        WeExternalContactDto.WeContactWay wcw = new WeExternalContactDto.WeContactWay();
        wcw.setScene(2);
        wcw.setType(1);
        wcw.setUser(new String[]{fissUserId});
        wcw.setState(WeConstans.FISSION_PREFIX + recordId);
        return wcw;
    }

    private WeTaskFissionRecord getTaskFissionRecordId(Long taskFissionId, String customerId, String customerName) {
        WeTaskFissionRecord record = WeTaskFissionRecord.builder()
                .taskFissionId(taskFissionId)
                .customerId(customerId)
                .customerName(customerName).build();
        List<WeTaskFissionRecord> searchExists = weTaskFissionRecordService.selectWeTaskFissionRecordList(record);
        WeTaskFissionRecord recordInfo;
        if (CollectionUtils.isNotEmpty(searchExists)) {
            recordInfo = searchExists.get(0);
        } else {
            int insertRows = weTaskFissionRecordService.insertWeTaskFissionRecord(record);
            if (insertRows > 0) {
                recordInfo = record;
            } else {
                throw new RuntimeException("生成海报异常：插入裂变记录失败");
            }
        }
        return recordInfo;
    }
}
