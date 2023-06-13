<template>
  <div>
    <el-form :inline="true" label-width="80px" label-position="left">
      <el-form-item>
        <!-- <el-select v-model="form.status">
          <el-option
            v-for="item in statusOptions"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          ></el-option>
        </el-select> -->
        <el-date-picker
          v-model="query.branchAwiatAccurateTime"
          type="datetime"
          :picker-options="pickerOptions"
          format="yyyy-MM-dd HH:mm"
          value-format="yyyy-MM-dd HH:mm"
          placeholder="请选择"
        ></el-date-picker>
      </el-form-item>
    </el-form>

    <el-table :data="list" v-loading="loading" style="margin-top: 12px">
      <el-table-column
        prop="nodeName"
        label="旅程节点"
        align="center"
      ></el-table-column>
      <el-table-column
        prop="expectedNum"
        label="预计触达数"
        align="center"
      ></el-table-column>
      <el-table-column
        prop="successNum"
        label="成功触达数"
        align="center"
      ></el-table-column>
      <el-table-column
        prop="failNum"
        label="未触达数"
        align="center"
      ></el-table-column>
      <el-table-column
        prop="reachRate"
        label="触达率"
        align="center"
        width="150"
      ></el-table-column>

      <el-table-column label="操作" align="center" width="180" fixed="right">
        <template #default="{ row }">
          <el-button type="text" size="mini" @click="touchClick(row.nodeId)"
            >触达内容</el-button
          >
          <el-button type="text" size="mini" @click="pepoleDetail(row.nodeId)"
            >人群明细</el-button
          >
        </template>
      </el-table-column>
    </el-table>
    <!-- <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="query.pageNum"
      :limit.sync="query.pageSize"
      @pagination="getList()"
    /> -->
    <el-dialog
      :title="dialogTitle"
      :visible.sync="dialogTableVisible"
      :width="dialogTitle === '触达内容' ? '400px' : '1236px'"
    >
      <div v-if="dialogTitle === '触达内容'" class="mob-style">
        <!-- <div class="mob-content">
          <svg-icon icon-class="phone-w" class="phone-icon" />
          <div class="mob-box">
            <div class="box-one">
              <div class="mob-top">
                <div class="mob-left">
                  <svg-icon icon-class="9_41" />
                </div>
                <div class="mob-right">
                  <svg-icon icon-class="signal" />
                  <svg-icon icon-class="Wifi" />
                  <svg-icon icon-class="electric" />
                </div>
              </div>
              <div class="mob-bottom">
                <span>×</span>
                <span>客户</span>
                <i class="el-icon-more content-icon"></i>
              </div>
            </div>
            <div class="box-two">
              <div class="time">2022-05-22 14:32:14</div>
              <div class="cotent-one">
                <div class="portrait"></div>
                <div class="triangle"></div>
                <div class="context">你好，这是一个文本信息</div>
              </div>
              <div class="cotent-one">
                <div class="portrait"></div>
                <div class="triangle"></div>
                <div class="conimg"></div>
              </div>
            </div>
          </div>
        </div> -->
        <preview-client :list="materialData" name="客户"></preview-client>
      </div>

      <div v-else class="mob-detail">
        <!-- 人群明细 -->
        <PopulationDetails :perdetail="perdetail" />
      </div>
    </el-dialog>
  </div>
</template>

<script>
import PopulationDetails from "./PopulationDetails";
import { contactDetails, reachContent } from "@/api/marketStrategy/journey.js";
import PreviewClient from "@/components/previewInMobileClient.vue";
export default {
  components: { PopulationDetails, PreviewClient },
  data() {
    return {
      query: {
        branchAwiatAccurateTime: '',
      },
      formList: {},
      statusOptions: [],
      list: [{ createBy: "123" }],
      dialogTitle: "人群明细",
      dialogTableVisible: false,
      loading: false,
      total: 0,
      perdetail: null, //人群明细
      id: null,
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() < new Date().setDate(new Date().getDate() - 1);
        },
      },
      materialData: {
        welcomeMsg: "",
        materialMsgList: [],
      },
    };
  },
  created() {
    this.id = this.$route.query.id;
    this.getList();
  },
  props: ["showDatePicker"],
  methods: {
    pepoleDetail(nodeId) {
      this.dialogTableVisible = true;
      this.dialogTitle = "人群明细";
      this.perdetail = nodeId;
    },

    getList() {
      contactDetails(this.$route.query.id).then((res) => {
        // console.log(res);
        this.list = res.data;
      });
    },
    // 获取触达明细内容
    touchClick(nodeId) {
      this.dialogTableVisible = true;
      this.dialogTitle = "触达内容";
      reachContent(nodeId).then((res) => {
        this.formList = res.data;
        if (this.formList && this.formList.length) {
          this.materialData = {
            welcomeMsg:
              this.formList.msgType === "text" ? this.formList.content : "",
            materialMsgList: this.formList
              ? this.setEditList(this.formList)
              : [],
          };
        }
      });
    },
    setEditList(list) {
      let arr = [];
      if (list && list.length) {
        list.forEach((dd) => {
          if (dd.msgType === "image") {
            let obj = {
              msgType: "0",
              materialUrl: dd.picUrl,
            };
            arr.push(obj);
          } else if (dd.msgType === "link") {
            let ob = {
              msgType: "8",
              materialName: dd.title,
              materialUrl: dd.linkUrl,
            };
            arr.push(ob);
          } else if (dd.msgType === "miniprogram") {
            let ff = {
              msgType: "9",
              digest: dd.appId,
              materialName: dd.title,
              coverUrl: dd.picUrl,
              materialUrl: dd.linkUrl,
            };
            arr.push(ff);
          }
        });
      }
      return arr;
    },
  },
};
</script>

<style lang="scss" scoped>
.content-icon {
  color: #333;
  font-size: 12px;
}
.mob-style {
  display: flex;
  justify-content: center;
  .mob-content {
    width: 230px;
    height: 471px;
    position: relative;
    .phone-icon {
      width: 100%;
      height: 100%;
    }
    .mob-box {
      position: absolute;
      top: 0;
      left: 0;
      padding: 11px 9px;
      width: 100%;
      height: 100%;
      display: flex;
      flex-direction: column;
      align-items: center;
      .box-one {
        padding: 0 8px;
        margin-bottom: 10px;
        width: 100%;
        .mob-top {
          padding: 8px 0;
          display: flex;
          justify-content: space-between;
          .mob-left {
            // width: 20px;
            width: 14px;
            height: 6px;
            .svg-icon {
              width: 30px;
              height: 14px;
            }
          }
          .mob-right {
            display: flex;
            width: 40px;
            .svg-icon {
              font-size: 16px;
              margin-left: 4px;
            }
          }
        }
        .mob-bottom {
          width: 100%;
          display: flex;
          justify-content: space-between;
          span:nth-child(1) {
            font-size: 16px;
            font-weight: normal;
            color: #222222;
            line-height: 11px;
            margin-left: 3px;
          }
          span:nth-child(2) {
            font-size: 12px;
            font-weight: 600;
            color: #222222;
            line-height: 11px;
          }
        }
      }
      .box-two {
        height: 400px;
        width: 206px;
        background-color: #fafafa;
        border-radius: 0 0 20px 20px;
        padding: 0 8px;
        .time {
          font-size: 8px;
          color: #cccccc;
          line-height: 12px;
          text-align: center;
          margin-top: 20px;
          margin-bottom: 20px;
        }
        .cotent-one {
          display: flex;
          .portrait {
            width: 20px;
            height: 20px;
            border-radius: 20px;
            box-shadow: 0px 1px 2px -3px rgba(0, 0, 0, 0.02);
            background-color: #fff;
          }
          .triangle {
            width: 0;
            height: 0;
            border: 3.5px solid;
            border-color: transparent #fff transparent transparent;
            margin-top: 7px;
          }
          .context {
            font-size: 10px;
            color: #222222;
            line-height: 29px;
            height: 29px;
            background: #ffffff;
            border-radius: 5px 5px 5px 5px;
            text-align: center;
            padding: 0 10px;
            margin-bottom: 15px;
          }
          .conimg {
            width: 93px;
            height: 93px;
            border-radius: 5px 5px 5px 5px;
            background-color: #fff;
          }
        }
      }
    }
  }
}
.el-icon-s-custom {
  font-size: 16px;
  // margin-left: 4px;
  color: #999;
  &.man {
    color: #13a2e8;
  }
  &.woman {
    color: #f753b2;
  }
}
.bfc-d + .bfc-d .el-checkbox:first-child {
  margin-left: 10px;
}
</style>
