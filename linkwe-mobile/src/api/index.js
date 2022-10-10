import request from "@/utils/request";
const wecom = window.lwConfig.services.wecom;
// const service = wecom + "/groupCode";

// 获取客户分析数据
export function getCustomerAnalysisData(params) {
  return request({
    url: wecom + "/operation/getCustomerAnalysisForApp",
    params,
  });
}

// 获取群分析数据
export function getGroupAnalysisData(params) {
  return request({
    url: wecom + "/operation/getGroupAnalysisByApp",
    params,
  });
}
// 获取企业轨迹
export function getCompanyDynamicsData(params) {
  return request({
    url: wecom + "/trajectory/findCompanyDynamics",
    params,
  });
}
