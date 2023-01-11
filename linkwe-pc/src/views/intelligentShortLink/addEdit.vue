<script>
export default {
  name: '',
  components: {},
  data() {
    return {
      currentActive: 0,
      form: {
        jumpType: 1,
        extensionType: 1,
        touchType: 0,
      },
      dictDesc: [],
      dictTouchType: Object.freeze({
        1: {
          name: '公众号',
          touchType: {
            0: { name: '文章', allName: '跳入微信-公众号-文章', tip: '跳转进入微信后，打开一篇公众号文章' },
            1: {
              name: '二维码',
              allName: '跳入微信-公众号-二维码',
              tip: '跳转进入微信后，展示一张公众号二维码，长按引导关注',
            },
          },
        },
        2: {
          name: '个人微信',
          touchType: {
            2: {
              name: '个人二维码',
              allName: '跳入微信-个人微信-个人二维码',
              tip: '跳转进入微信后，展示一张个人二维码，长按扫码添加好友',
            },
            3: {
              name: '群二维码',
              allName: '跳入微信-个人微信-群二维码',
              tip: '跳转进入微信后，展示一张微信群二维码，长按扫码入群',
            },
          },
        },
        3: {
          name: '企业微信',
          touchType: {
            4: {
              name: '员工活码',
              allName: '跳入微信-企业微信-员工活码',
              tip: '跳转进入微信后，展示一张企微员工活码，长按扫码添加企业员工',
            },
            5: {
              name: '客群活码',
              allName: '跳入微信-企业微信-客群活码',
              tip: '跳转进入微信后，展示一张企微客群活码，长按扫码入群',
            },
            6: {
              name: '门店导购活码',
              allName: '跳入微信-企业微信-门店导购码',
              tip: '跳转进入微信后，展示一张门店导购码，长按扫码添加附近门店的导购',
            },
            8: {
              name: '门店群活码',
              allName: '跳入微信-企业微信-门店群活码',
              tip: '跳转进入微信后，展示一张门店群活码，长按扫码进入附近的门店群',
            },
          },
        },
        4: {
          name: '小程序',
          touchType: {
            7: {
              name: '个人小程序',
              allName: '跳入微信-小程序-个人小程序',
              tip: '跳转进入微信后，直接打开一个个人小程序',
            },
            9: {
              name: '企业小程序',
              allName: '跳入微信-小程序-企业小程序',
              tip: '跳转进入微信后，直接打开一个企业小程序',
            },
            10: {
              name: '小程序二维码',
              allName: '跳入微信-小程序-小程序二维码',
              tip: '跳转进入微信后，展示一张小程序二维码，长按扫码打开小程序',
            },
          },
        },
      }),
    }
  },
  computed: {},
  watch: {},
  created() {
    Object.values(this.dictTouchType).forEach((element) => Object.assign(this.dictDesc, element.touchType))
  },
  mounted() {},
  methods: {
    nextStep() {
      this.currentActive++
    },
  },
}
</script>

<template>
  <div>
    <div class="g-card g-pad20">
      <el-steps style="margin-top: 10px" :active="currentActive" align-center>
        <el-step title="短链类型"></el-step>
        <el-step title="内容设置"></el-step>
        <el-step title="生成短链"></el-step>
      </el-steps>
    </div>

    <div class="g-card g-pad20" v-show="currentActive === 0">
      <el-form label-width="">
        <el-form-item label="跳转类型">
          <el-radio-group v-model="form.jumpType">
            <el-radio-button :label="1">跳入微信</el-radio-button>
            <el-radio-button :label="2">跳出微信</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="推广类型">
          <el-radio-group v-model="form.extensionType">
            <el-radio-button v-for="(item, key) in dictTouchType" :key="key" :label="key">
              {{ item.name }}
            </el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="触达类型">
          <el-radio-group v-model="form.touchType">
            <template v-for="(item, key) in dictTouchType">
              <div v-show="form.extensionType == key" :key="key">
                <el-radio-button v-for="(unit, unique) in item.touchType" :key="key + '-' + unique" :label="unique">
                  {{ unit.name }}
                </el-radio-button>
              </div>
            </template>
          </el-radio-group>
        </el-form-item>
        <div class="g-card g-pad20" style="background: #eee">
          <span>{{ dictDesc[form.touchType].tip }}</span>
        </div>
      </el-form>
    </div>

    <div v-show="currentActive === 1">
      <div class="g-card g-pad20">
        <el-form ref="form" :model="form" label-width="80px">
          <el-form-item label="短链类型">
            <span>{{ dictDesc[form.touchType].allName }}</span>
          </el-form-item>
          <el-form-item label="短链名称">
            <el-input clearable v-model="form.shortLinkName" placeholder="请输入"></el-input>
          </el-form-item>

          <!-- 公众号文章 -->
          <template v-if="form.touchType == 0">
            <el-form-item label="公众号文章链接">
              <el-input
                clearable
                v-model="form.longLink"
                placeholder="请输入"
                maxlength="30"
                show-word-limit></el-input>
              <div class="tips">请在公众号后台文章发布列表页中获取并复制文章的永久链接</div>
            </el-form-item>
          </template>
          <!-- 公众号二维码 -->
          <template v-else-if="form.touchType == 1">
            <el-form-item label="公众号名称">
              <el-input clearable v-model="form.name" placeholder="请输入" maxlength="30" show-word-limit></el-input>
            </el-form-item>
            <el-form-item label="公众号描述">
              <el-input
                clearable
                v-model="form.describe"
                placeholder="请输入"
                maxlength="30"
                show-word-limit></el-input>
            </el-form-item>
            <el-form-item label="公众号logo">
              <upload class="image-uploader" :fileUrl.sync="form.avatar" type="0"></upload>
            </el-form-item>
            <el-form-item label="公众号二维码">
              <upload class="image-uploader" :fileUrl.sync="form.qrCode" type="0"></upload>
            </el-form-item>
          </template>
          <!-- 个人二维码 -->
          <template v-else-if="form.name">
            <el-form-item label="微信名称">
              <el-input clearable v-model="form.name" placeholder="请输入" maxlength="30" show-word-limit></el-input>
            </el-form-item>
            <el-form-item label="微信描述">
              <el-input clearable v-model="form.name" placeholder="请输入" maxlength="30" show-word-limit></el-input>
            </el-form-item>
            <el-form-item label="微信logo">
              <upload class="image-uploader" :fileUrl.sync="form.logoUrl" type="0"></upload>
            </el-form-item>
            <el-form-item label="微信二维码">
              <upload class="image-uploader" :fileUrl.sync="form.logoUrl" type="0"></upload>
            </el-form-item>
          </template>
          <!--  -->
          <template v-else-if="form.name">
            <el-form-item label="公众号文章链接">
              <el-input clearable v-model="form.name" placeholder="请输入" maxlength="30" show-word-limit></el-input>
            </el-form-item>
          </template>
          <!--  -->
          <template v-else-if="form.name">
            <el-form-item label="公众号文章链接">
              <el-input clearable v-model="form.name" placeholder="请输入" maxlength="30" show-word-limit></el-input>
            </el-form-item>
          </template>
          <!--  -->
          <template v-else-if="form.name">
            <el-form-item label="公众号文章链接">
              <el-input clearable v-model="form.name" placeholder="请输入" maxlength="30" show-word-limit></el-input>
            </el-form-item>
          </template>
          <!--  -->
          <template v-else-if="form.name">
            <el-form-item label="公众号文章链接">
              <el-input clearable v-model="form.name" placeholder="请输入" maxlength="30" show-word-limit></el-input>
            </el-form-item>
          </template>
          <!--  -->
          <template v-else-if="form.name">
            <el-form-item label="公众号文章链接">
              <el-input clearable v-model="form.name" placeholder="请输入" maxlength="30" show-word-limit></el-input>
            </el-form-item>
          </template>
          <!--  -->
          <template v-else-if="form.name">
            <el-form-item label="公众号文章链接">
              <el-input clearable v-model="form.name" placeholder="请输入" maxlength="30" show-word-limit></el-input>
            </el-form-item>
          </template>
          <!--  -->
          <template v-else-if="form.name">
            <el-form-item label="公众号文章链接">
              <el-input clearable v-model="form.name" placeholder="请输入" maxlength="30" show-word-limit></el-input>
            </el-form-item>
          </template>
          <!--  -->
          <template v-else-if="form.name">
            <el-form-item label="公众号文章链接">
              <el-input clearable v-model="form.name" placeholder="请输入" maxlength="30" show-word-limit></el-input>
            </el-form-item>
          </template>
        </el-form>
      </div>

      <div class="g-card g-pad20">
        <PhoneTemplate></PhoneTemplate>
      </div>
    </div>

    <div class="mt20">
      <el-button plain @click="$router.back()">取消</el-button>
      <el-button type="primary" @click="nextStep()">下一步</el-button>
    </div>
  </div>
</template>

<style lang="less" scoped></style>
