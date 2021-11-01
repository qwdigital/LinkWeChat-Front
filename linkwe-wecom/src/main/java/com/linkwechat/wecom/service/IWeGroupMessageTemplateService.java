package com.linkwechat.wecom.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.linkwechat.wecom.domain.WeGroupMessageTemplate;
import com.linkwechat.wecom.domain.query.WeAddGroupMessageQuery;
import com.linkwechat.wecom.domain.vo.WeGroupMessageDetailVo;

import java.util.List;

/**
 * 群发消息模板Service接口
 *
 * @author ruoyi
 * @date 2021-10-27
 */
public interface IWeGroupMessageTemplateService extends IService<WeGroupMessageTemplate> {

    /**
     * 查询列表
     */
    List<WeGroupMessageTemplate> queryList(WeGroupMessageTemplate weGroupMessageTemplate);

    /**
     * 获取群发消息详情
     * @param id 模板id
     * @return
     */
    WeGroupMessageDetailVo getGroupMsgTemplateDetail(Long id);

    /**
     * 创建群发消息
     * @param query
     */
    void addGroupMsgTemplate(WeAddGroupMessageQuery query);

    /**
     * 取消定时发送
     * @param asList
     */
    void cancelByIds(List<Long> asList);

    /**
     * 同步消息发送结果
     * @param asList
     */
    void syncGroupMsgSendResultByIds(List<Long> asList);
}