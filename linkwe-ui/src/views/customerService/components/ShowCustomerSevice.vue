<template>
  <div class="show">
    <div class="show_img">
      <img :src="url" style="width: 40px; height: 40px"></img>
    </div>
    <div class="show_name" :style="showicon ? '' : showiconStyle">
      <div>{{name}}</div>
      <div class="company" v-if="showicon">
        @{{companyName}}
      </div>
    </div>
  </div>
</template>
<script>
  import Cookies from 'js-cookie'

  import * as api from '@/api/enterpriseId'
  export default {
    name: 'show-customer-service',
    props: {
      url: {
        type: String,
        default: '测试'
      },
      name: {
        type: String,
        default: '测试'
      },
      showicon: {
        type: Boolean,
        default: false
      }
    },
    data () {
      return {
        companyName: '',
        showiconStyle: {
          'justify-content': 'center'
        }
      }
    },
    methods: {
      getDetail () {
        this.loading = true
        api.getDetail()
          .then(({ data }) => {
            this.companyName = data.companyName
            Cookies.set('companyName', data.companyName)
          })
          .catch(() => {
            this.loading = false
          })
      },
    },
    created () {
      if (!Cookies.get('companyName')) {
        this.getDetail()
      } else {
        this.companyName = Cookies.get('companyName')
      }
    }
  }
</script>
<style lang="scss" scoped>
  .show {
    height: 40px;
    display: flex;
    align-items: center;
    .show_img {
      margin-right: 7px;
      height: 40px;
      width: 40px;
    }
    .show_name {
      height: 40px;
      line-height: normal;
      display: flex;
      flex-direction: column;
      align-items: flex-start;
      justify-content: space-between;
      font-size: 12px;
      .company {
        color: #ffcf0e;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }
    }
  }
</style>