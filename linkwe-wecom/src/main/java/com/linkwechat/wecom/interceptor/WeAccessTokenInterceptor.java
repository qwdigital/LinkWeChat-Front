package com.linkwechat.wecom.interceptor;

import cn.hutool.json.JSONUtil;
import com.dtflys.forest.exceptions.ForestRuntimeException;
import com.dtflys.forest.http.ForestHeader;
import com.dtflys.forest.http.ForestRequest;
import com.dtflys.forest.http.ForestResponse;
import com.dtflys.forest.interceptor.Interceptor;
import com.dtflys.forest.utils.ForestDataType;
import com.linkwechat.common.annotation.Log;
import com.linkwechat.common.config.WeComeConfig;
import com.linkwechat.common.exception.wecom.WeComException;
import com.linkwechat.framework.web.domain.server.Sys;
import com.linkwechat.wecom.domain.dto.WeResultDto;
import com.linkwechat.wecom.service.IWeAccessTokenService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Arrays;

/**
 * @description: 微信token拦截器
 * @author: HaoN
 * @create: 2020-08-27 22:36
 **/
@Component
public class WeAccessTokenInterceptor implements Interceptor{


    @Autowired
    private  IWeAccessTokenService iWeAccessTokenService;


    @Autowired
    private WeComeConfig weComeConfig;



    /**
     * 该方法在请求发送之前被调用, 若返回false则不会继续发送请求
     */
    @Override
    public boolean beforeExecute(ForestRequest request) {
        request.setDataType(ForestDataType.JSON);

        String uri=request.getUrl().replace("http://","");

        request.setContentType("application/json");
//        if(Arrays.asList(weComeConfig.getFileUplodUrl()).contains(uri)){
//            request.setContentType("application/json");
//        }else{
//            request.setContentType("multipart/form-data");
//        }



        // 添加请求参数access_token
        if(!weComeConfig.getNoAccessTokenUrl().equals(uri)){
            request.addQuery("access_token",
                    Arrays.asList(weComeConfig.getNeedContactTokenUrl()).contains(uri)?
                            iWeAccessTokenService.findContactAccessToken():
                            iWeAccessTokenService.findCommonAccessToken());
        }

        //添加服务器统一请求地址
        request.setUrl(weComeConfig.getServerUrl()+weComeConfig.getWeComePrefix()+uri);

        return true;
    }



    /**
     *  请求发送失败时被调用
     * @param e
     * @param forestRequest
     * @param forestResponse
     */
    @Override
    public void onError(ForestRuntimeException e, ForestRequest forestRequest, ForestResponse forestResponse) {


    }


    /**
     *  请求成功调用(微信端错误异常统一处理)
     * @param o
     * @param forestRequest
     * @param forestResponse
     */
    @Override
    public void onSuccess(Object o, ForestRequest forestRequest, ForestResponse forestResponse) {

        WeResultDto weResultDto = JSONUtil.toBean(forestResponse.getContent(), WeResultDto.class);

        if(null != weResultDto.getErrcode() && weResultDto.getErrcode() != 0){

            throw new ForestRuntimeException(forestResponse.getContent());

        }

    }


}