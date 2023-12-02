<template>
  <CacheElTabs #="{ opened }">
    <el-tab-pane label="活码信息">
      <el-row style="margin-top: 10px" type="flex" :gutter="10">
        <el-col>
          <div class="g-card">
            <div class="g-card-title fxbw">
              基本信息
              <el-button type="primary" @click="editFn">编辑</el-button>
            </div>
            <el-form label-position="right" label-width="100px">
              <el-form-item label="活码名称">{{ form.name }}</el-form-item>
              <el-form-item label="活码分组">{{ form.qrGroupName }}</el-form-item>
              <el-form-item label="自动通过好友">
                <el-switch :value="form.autoAdd" :active-value="1" :inactive-value="0" disabled></el-switch>
              </el-form-item>
              <el-form-item label="新客标签">
                <TagEllipsis :list="form.qrTags" limit="10" defaultProps="tagName" emptyText></TagEllipsis>
              </el-form-item>
            </el-form>
          </div>
          <div class="g-card">
            <div class="g-card-title">活码员工</div>
            <!-- <template v-if="form.ruleType === 1">
            <div class="pad20">
              <div class="content pad20">
                <el-form label-position="right" label-width="100px">
                  <el-form-item label="排班员工">
                    <el-tag v-for="(data, key) in form.qrUserInfos" :key="key">{{data.businessName}}</el-tag>
                  </el-form-item>
                  <el-form-item label="工作周期">
                    <el-checkbox-group v-model="checkList">
                      <el-checkbox label="周一" disabled></el-checkbox>
                      <el-checkbox label="周二" disabled></el-checkbox>
                      <el-checkbox label="周三" disabled></el-checkbox>
                      <el-checkbox label="周四" disabled></el-checkbox>
                      <el-checkbox label="周五" disabled></el-checkbox>
                      <el-checkbox label="周六" disabled></el-checkbox>
                      <el-checkbox label="周日" disabled></el-checkbox>
                    </el-checkbox-group>
                  </el-form-item>
                  <el-form-item label="在线时间">
                    <el-time-select disabled value="00:00" placeholder="任意时间点">
                    </el-time-select>
                    <el-time-select arrow-control disabled value="23:59" placeholder="任意时间点">
                    </el-time-select>
                  </el-form-item>
                </el-form>
              </div>
            </div>
          </template>-->

            <div class="pad20" v-for="(unit, index) in form.qrUserInfos" :key="index">
              <div class="content pad20">
                <el-form label-position="right" label-width="100px">
                  <el-form-item label="排班员工">
                    <el-tag v-for="(data, key) in unit.weQrUserList" :key="key">{{ data.userName }}</el-tag>
                  </el-form-item>
                  <el-form-item label="工作周期">
                    <el-checkbox-group v-if="unit.type === 0" v-model="checkList">
                      <el-checkbox label="周一" disabled></el-checkbox>
                      <el-checkbox label="周二" disabled></el-checkbox>
                      <el-checkbox label="周三" disabled></el-checkbox>
                      <el-checkbox label="周四" disabled></el-checkbox>
                      <el-checkbox label="周五" disabled></el-checkbox>
                      <el-checkbox label="周六" disabled></el-checkbox>
                      <el-checkbox label="周日" disabled></el-checkbox>
                    </el-checkbox-group>
                    <el-checkbox-group v-else v-model="unit.weekday">
                      <el-checkbox label="1" disabled>周一</el-checkbox>
                      <el-checkbox label="2" disabled>周二</el-checkbox>
                      <el-checkbox label="3" disabled>周三</el-checkbox>
                      <el-checkbox label="4" disabled>周四</el-checkbox>
                      <el-checkbox label="5" disabled>周五</el-checkbox>
                      <el-checkbox label="6" disabled>周六</el-checkbox>
                      <el-checkbox label="7" disabled>周日</el-checkbox>
                    </el-checkbox-group>
                  </el-form-item>
                  <el-form-item v-if="unit.type === 0" v-model="checkList" label="在线时间">
                    <el-time-select
                      style="width: 40%"
                      disabled
                      v-model="defaultStart"
                      placeholder="任意时间点"></el-time-select>
                    -
                    <el-time-select
                      style="width: 40%"
                      v-model="defaultEnd"
                      disabled
                      value="23:59"
                      placeholder="任意时间点"></el-time-select>
                  </el-form-item>
                  <el-form-item v-else label="在线时间">
                    <el-time-select
                      style="width: 40%"
                      disabled
                      v-model="unit.beginTime"
                      placeholder="任意时间点"></el-time-select>
                    -
                    <el-time-select
                      style="width: 40%"
                      disabled
                      v-model="unit.endTime"
                      placeholder="任意时间点"></el-time-select>
                  </el-form-item>
                </el-form>
              </div>
            </div>
          </div>

          <div class="g-card overhide">
            <div class="g-card-title">欢迎语设置</div>
            <el-form label-position="right" label-width="100px" disabled>
              <el-form-item label="欢迎语类型">
                <el-radio-group v-model="form.qrWelcomeOpen" @change="">
                  <el-radio :label="1" v-if="form.qrWelcomeOpen == 1">不发送欢迎语</el-radio>
                  <el-radio :label="2" v-if="form.qrWelcomeOpen == 2">
                    活码欢迎语
                    <div class="bfc-p">
                      <el-checkbox v-model="form.qrPriorityUserWelcome" :true-label="0" :false-label="1">
                        如果员工有员工欢迎语，则优先发送员工欢迎语
                      </el-checkbox>
                    </div>
                  </el-radio>
                </el-radio-group>
              </el-form-item>
            </el-form>
          </div>
        </el-col>
        <el-col style="flex-basis: auto">
          <CodeLink :data="form" />
          <div class="g-card" style="flex: 1" v-if="form.qrWelcomeOpen == 2">
            <div class="g-card-title">欢迎语预览</div>
            <PreviewInPhone :originList="form.materialMsgList" :templateInfo="form.welcomeMsg"></PreviewInPhone>
          </div>
        </el-col>
      </el-row>
    </el-tab-pane>
    <el-tab-pane label="活码统计">
      <statistics />
    </el-tab-pane>
  </CacheElTabs>
</template>

<script>
import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'
import { getDetail, getTotal, downloadBatch } from '@/api/drainageCode/staff'
export default {
  name: 'CodeDetail',
  components: {
    PreviewInPhone,
    statistics: defineAsyncComponent(() => import('./statistics')),
    CodeLink: defineAsyncComponent(() => import('../components/CodeLink')),
  },
  data() {
    return {
      defaultStart: '00:00',
      defaultEnd: '23:59',
      form: {},
      checkList: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
      // 遮罩层
      loading: false,
      // 选中数组
      ids: [],
      // 表格数据
      list: [],
      // 日期范围
      dateRange: [],
      // 表单参数
      form: {},
      // 查询参数
      query: {
        qrId: '',
        beginTime: undefined,
        endTime: undefined,
      },
      type: {
        1: '单人',
        2: '多人',
        3: '批量单人',
      },
      timeRange: 7,
    }
  },
  created() {
    let id = this.$route.query.id
    this.query.qrId = id
    id && this.getDetail(id)
  },
  mounted() {
    // var clipboard = new this.ClipboardJS('.copy-btn')
  },
  methods: {
    editFn() {
      this.$router.push({
        path: 'add',
        query: {
          id: this.form.id,
        },
      })
    },
    /** 获取详情 */
    getDetail(id) {
      this.loading = true
      getDetail(id).then((res) => {
        this.form = res.data
        if (this.form.qrAttachments && this.form.qrAttachments.length) {
          this.form.welcomeMsg = this.form.qrAttachments[0].content
          this.form.materialMsgList = this.form.qrAttachments
        }
        this.form.qrUserInfos.forEach((dd) => {
          if (dd.workCycle) {
            dd.weekday = dd.workCycle.split(',')
          } else {
            dd.weekday = []
          }
        })
        this.loading = false
      })
    },
    setEditList(list) {
      let arr = []
      if (list && list.length) {
        list.forEach((dd) => {
          if (dd.realType === 0) {
            let obj = {
              id: dd.materialId,
              mediaType: '0',
              materialUrl: dd.picUrl,
            }
            arr.push(obj)
          } else if (dd.realType === 2) {
            let obj = {
              id: dd.materialId,
              mediaType: '2',
              materialUrl: dd.fileUrl,
              coverUrl: dd.picUrl,
              digest: dd.description,
              materialName: dd.title,
            }
            arr.push(obj)
          } else if (dd.realType === 3) {
            let obj = {
              id: dd.materialId,
              mediaType: '3',
              materialUrl: dd.fileUrl,
              digest: dd.description,
              materialName: dd.title,
            }
            arr.push(obj)
          } else if (dd.realType === 4) {
            let obj = {
              id: dd.materialId,
              mediaType: '4',
              content: dd.content,
            }
            arr.push(obj)
          } else if (dd.realType === 9) {
            let obj = {
              id: dd.materialId,
              mediaType: '9',
              content: dd.content,
              coverUrl: dd.picUrl,
              materialUrl: dd.linkUrl,
              materialName: dd.title,
            }
            arr.push(obj)
          } else if (dd.realType === 8) {
            let ob = {
              id: dd.materialId,
              mediaType: '8',
              materialName: dd.title,
              materialUrl: dd.linkUrl,
              materialName: dd.title,
            }
            arr.push(ob)
          } else if (dd.realType === 11) {
            let ff = {
              id: dd.materialId,
              mediaType: '11',
              digest: dd.appId,
              materialName: dd.title,
              coverUrl: dd.picUrl,
              materialUrl: dd.fileUrl,
            }
            arr.push(ff)
          } else if (dd.realType === 12) {
            let ff = {
              id: dd.materialId,
              mediaType: '12',
              digest: dd.description,
              materialUrl: dd.fileUrl,
              coverUrl: dd.picUrl,
              content: dd.content,
              materialName: dd.title,
            }
            arr.push(ff)
          } else if (dd.realType === 5) {
            let obj = {
              id: dd.materialId,
              mediaType: '5',
              materialUrl: dd.fileUrl,
              materialName: dd.title,
            }
            arr.push(obj)
          }
        })
      }
      return arr
    },

    getHandledValue(num) {
      return num < 10 ? '0' + num : num
    },
    getTime(datePar) {
      const d = datePar ? new Date(datePar) : new Date()
      const year = d.getFullYear()
      const month = this.getHandledValue(d.getMonth() + 1)
      const date = this.getHandledValue(d.getDate())
      return year + '-' + month + '-' + date
    },
  },
}
</script>

<style lang="scss" scoped>
.top {
  align-items: flex-start;
}

.title {
  font-size: 16px;
  font-weight: 600;
  margin: 0 0 20px;
}

.crumb {
  font-size: 12px;

  font-weight: 400;
  color: var(--font-black-4);
  display: flex;
}

.crumb- {
  // 一级 页面标题
  &title {
    display: flex;
    flex-direction: column;
    justify-content: center;
    height: 90px; // line-height: 90px;
    font-size: 18px;
    font-weight: 500;
    color: var(--font-black);
    padding: 0 20px;
    background: var(--bg-white);
    border-top-left-radius: 4px;
    border-top-right-radius: 4px;
  }
}

.content {
  margin-top: 20px;
  border-radius: 4px;
  border: 1px solid var(--border-black-10);
  &:first-child {
    margin-top: 0;
  }
}
</style>
