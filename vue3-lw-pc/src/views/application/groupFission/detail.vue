<template>
  <div>
    <el-tabs v-model="activeName">
      <el-tab-pane label="任务信息" name="first">
        <el-row :gutter="20" type="flex">
          <el-col>
            <div class="g-card">
              <div style="display: flex; justify-content: space-between;">
                <div class="info_title">基本信息</div>
                <el-button
                  v-if="form.fassionState == 1"
                  type="primary"
                  @click="$router.push({ path: './add', query: { id: $route.query.id } })"
                >
                  编辑
                </el-button>
              </div>
              <FassionBase :baseData="form" :isDetail="true">
                <div slot>
                  <el-form-item label="任务状态" prop="fassionState">
                    <el-tag :type="form.fassionState == 1 ? 'info' : form.fassionState == 3 ? 'danger' : ''">
                      {{ setStatus(form) }}
                    </el-tag>
                  </el-form-item>
                </div>
              </FassionBase>
            </div>
            <div class="g-card">
              <div class="info_title">任务设置</div>
              <FassionSettingVue :baseData="form" :isDetail="true"></FassionSettingVue>
            </div>
            <div class="g-card">
              <div class="info_title">兑奖规则</div>
              <FassionRules :baseData="form" :isDetail="true"></FassionRules>
            </div>
          </el-col>
          <el-col style="flex-basis: 370px;">
            <div class="g-card">
              <PreviewInPhone name="客群" :list="[news]" :templateInfo="form.content"></PreviewInPhone>
            </div>
          </el-col>
        </el-row>
      </el-tab-pane>
      <el-tab-pane label="任务统计" name="second">
        <Statistics v-if="form.id" :fassionType="form.fassionType"></Statistics>
      </el-tab-pane>
      <el-tab-pane label="裂变明细" name="third">
        <DetailTable></DetailTable>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  import { getFassionDetail } from '../taskGroup/api'
  import FassionBase from '../common/FassionBase.vue'
  import FassionSettingVue from '../common/FassionSetting.vue'
  import FassionRules from '../common/FassionRules.vue'
  import Statistics from '../common/Statistics.vue'
  import DetailTable from './detail-table.vue'
  import PreviewInPhone from '@/components/ContentCenter/PreviewInPhone'
  export default {
    name: 'task-group-detail',
    components: {
      FassionBase,
      FassionSettingVue,
      FassionRules,
      Statistics,
      DetailTable,
      PreviewInPhone
    },
    data() {
      return {
        activeName: 'first',
        form: {
          fassionType: 1,
          fassionName: '',
          fassionStartTime: '',
          fassionEndTime: '',
          executeUserOrGroup: null,
          posterId: '',
          posterUrl: '',
          addWeUserOrGroupCode: {
            addWeUser: {
              executeUserCondit: {
                change: false,
                weUserIds: []
              },
              executeDeptCondit: {
                change: false,
                deptIds: [],
                posts: []
              }
            },
            addGroupCode: {
              autoCreateRoom: 0,
              roomBaseName: '',
              roomBaseId: null,
              chatIdList: '',
              groupNames: ''
            }
          },
          content: '',
          exchangeTip: null,
          exchangeType: 3,
          exchangeContent: {
            redemptionLink: '',
            redemptionRule: '',
            weUserId: '',
            userName: ''
          }
        },
        statusType: [
          { name: '待开始', key: 1 },
          { name: '进行中', key: 2 },
          { name: '已结束', key: 3 },
          { name: '已暂停', key: 4 }
        ],
        news: {
          materialName: '',
          digest: '',
          coverUrl: '',
          mediaType: '12'
        }
      }
    },
    methods: {
      setStatus(data) {
        let str = ''
        this.statusType.forEach((dd) => {
          if (dd.key == data.fassionState) {
            str = dd.name
          }
        })
        return str
      }
    },
    created() {
      if (this.$route.query.id) {
        getFassionDetail(this.$route.query.id).then((res) => {
          this.form = res.data
          this.news.digest = this.form.activeDescr
          this.news.materialName = this.form.activeTitle
          if (this.form.activeCoverType == 2) {
            this.news.coverUrl = this.form.activeCoverUrl
          } else {
            this.news.coverUrl = this.form.wematerial.materialUrl
          }
        })
      }
    }
  }
</script>

<style lang="scss" scoped>
  .info_title {
    font-size: 16px;
    font-weight: 600;
    color: var(--font-black);
    margin-bottom: 10px;
  }
</style>
