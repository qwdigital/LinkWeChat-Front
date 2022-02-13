<template>
	<div class="preview">
		<div class="title">{{name}}</div>
		<div class="content">
			<div v-if="def ==='info'">
				<div class="show">
					<div class="show_img">
						<img :src="avator" style="width: 40px; height: 40px"></img>
					</div>
					<div class="show_name">
						<div class="length-limit">{{call}} &nbsp;&nbsp; @{{companyName}}</div>
						<div class="sub">
							{{call}}为你服务
						</div>
					</div>
				</div>
			</div>
			<div v-else>
				<div class="show">
					<div class="show_img">
						<img :src="avator" style="width: 40px; height: 40px"></img>
					</div>
					<div class="show_name">
						<div class="length-limit">{{call}}</div>
						<div class="company">
							@{{companyName}}
						</div>
					</div>
				</div>
				<div class="comp">
					企业信息
				</div>
				<div class="company-info">
					<span>企业</span>
					<span style="color: #999;">{{companyName}}</span>
					<span style="color: #999;">></span>
				</div>
			</div>
		</div>
	</div>
</template>
<script>
	import Cookies from 'js-cookie'
	import ShowCustomerService from "../components/ShowCustomerSevice.vue"

	import hearder from '@/assets/drainageCode/header.png'
	import * as api from '@/api/enterpriseId'
	export default {
		name: 'preview-client',
		components: {
			ShowCustomerService
		},
		props: {
			name: {
				type: String,
				default: "客服"
			},
			def: {
				type: String,
				default: 'info'
			},
			avator: {
				type: String,
				default: ''
			},
			call: {
				type: String,
				defalut: ''
			}
		},
		data () {
			return {
				hearder: hearder,
				companyName: ''
			}
		},
		computed: {},
		created () { },
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
	.preview {
	  margin: 0 auto;
	  position: relative;
	  width: 300px;
	  height: 640px;
	  background: url(../../../assets/drainageCode/preview-bg.png);
	  background-repeat: no-repeat;
	  background-size: 100% 100%;

	  .title {
	    position: absolute;
	    top: 37px;
	    left: 50%;
	    transform: translateX(-50%);
	    font-size: 14px;
	    font-family: PingFangSC-Regular, PingFang SC;
	    font-weight: 400;
	    color: #333333;
	  }

	  .content {
	    position: absolute;
	    height: 545px;
	    width: 280px;
	    overflow-y: auto;
	    top: 70px;
	    left: 50%;
	    transform: translateX(-50%);
	    border-bottom-left-radius: 20px;
	    border-bottom-right-radius: 20px;
	    .comp {
	      // line-height: 40px;
	      font-size: 12px;
	      color: #333;
	      // height: 40px;
	      padding: 10px;
	      background-color: #f5f5f5;
	      // margin: 10px -20px;
	    }
	    .company-info {
	      background-color: #fff;
	      padding: 10px;
	      font-size: 14px;
	      display: flex;
	      justify-content: space-between;
	    }
	    .show {
	      padding: 10px;
	      // height: 40px;
	      background-color: #fff;

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
	        .sub {
	          font-size: 12px;
	          font-family: PingFangSC-Regular, PingFang SC;
	          font-weight: 400;
	          // color: #999999;
	        }
	        .length-limit {
	          width: 200px;
	          white-space: nowrap;
	          text-overflow: ellipsis;
	          overflow: hidden;
	        }
	      }
	    }
	  }
	}
</style>
