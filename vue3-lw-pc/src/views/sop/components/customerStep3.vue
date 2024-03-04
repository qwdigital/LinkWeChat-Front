<template>
  <div style="margin-top: 10px">
    <div class="g-card">
      <div class="g-card-title">内容配置</div>
      <div>
        <el-row type="flex">
          <el-col style="flex-basis: 550px">
            <template v-for="(unit, key) in list" :key="key">
              <div class="unit" :class="{ active: currentIndex === key }" @click.capture="changeTab(key)">
                <!-- :read="currentIndex !== key" -->
                <PushTimeUnit
                  :key="key"
                  :dateType="initData.businessType"
                  :init="unit"
                  @update="getUpdate($event, key)"></PushTimeUnit>
              </div>
            </template>
            <div class="operation_con">
              <el-button icon="el-icon-plus" @click="addItem" type="primary" plain>添加推送</el-button>
            </div>
          </el-col>
          <el-col style="background: var(--color-light-11); padding: 20px; border-radius: 0 6px 6px 0">
            <div class="right_title">
              <div class="sub_con">
                <span v-if="initData.businessType !== 2">第{{ list[currentIndex].pushTimePre }}天</span>
                <span v-else>{{ list[currentIndex].pushTimePre }}</span>
                {{ list[currentIndex].pushStartTime }}—{{ list[currentIndex].pushEndTime }}内推送
              </div>
              <div>
                <el-button type="primary" plain @click="setPreview">预览</el-button>
                <el-button type="primary" v-if="list.length != 1" plain @click="deleteFn">删除</el-button>
              </div>
            </div>
            <SendContent
              :sendType="initData.sendType"
              ref="sendContent"
              :baseData="list[currentIndex].attachments"
              @update="getAttachments"></SendContent>
          </el-col>
        </el-row>
      </div>
    </div>
    <div class="g-footer-sticky">
      <el-button plain @click="next(2)">上一步</el-button>
      <el-button type="primary" @click="next(4)">下一步</el-button>
    </div>
    <el-dialog title="预览" v-model="dialogVisible" width="30%">
      <show-in-phone v-if="dialogVisible" :list="previewList"></show-in-phone>
    </el-dialog>
  </div>
</template>
<script>
import ShowInPhone from './ShowInPhone'
import SendContent from './SendContent.vue'
import PushTimeUnit from './PushTimeUnit.vue'

export default {
  name: 'customer-step-3',
  components: {
    PushTimeUnit,
    SendContent,
    ShowInPhone,
  },
  props: {
    initData: {
      type: Object,
      default: {
        weSopPushTimes: [
          {
            pushStartTime: '',
            pushEndTime: '',
            pushTimeType: 3,
            pushTimePre: '',
            attachments: [],
          },
        ],
      },
    },
  },
  data() {
    return {
      dialogVisible: false,
      currentIndex: 0,
      list: [],
      previewList: [],
    }
  },
  methods: {
    setPreview() {
      this.previewList = this.$refs.sendContent.preview()
      this.dialogVisible = true
    },
    getAttachments(data) {
      this.list[this.currentIndex].attachments = data
    },
    checkData() {
      if (
        !this.list[this.currentIndex].pushStartTime ||
        !this.list[this.currentIndex].pushEndTime ||
        !this.list[this.currentIndex].pushTimePre
      ) {
        this.msgError('请选填完整时间或周期！')
        return false
      }
      if (!this.$refs.sendContent.submit()) {
        return false
      }
      return true
    },
    next(type) {
      if (type == 4) {
        if (!this.checkData()) {
          return
        }
        if (!this.setCheckTimeFn()) {
          return
        }
        if (!this.checkTimePoint()) {
          return
        }
      }
      this.$emit('stepFn', type, { weSopPushTimes: this.list })
    },
    changeTab(key) {
      if (key === this.currentIndex) {
        return
      }
      if (this.checkData()) {
        this.currentIndex = key
      }
    },
    addItem() {
      if (this.checkData()) {
        let obj = {
          pushStartTime: '',
          pushEndTime: '',
          pushTimeType: 3,
          pushTimePre: '',
          attachments: [],
        }
        this.list.push(obj)
        this.currentIndex = this.list.length - 1
      }
    },
    getUpdate(data, index) {
      this.list[index] = data
    },
    deleteFn() {
      this.$confirm('是否确认删除此条SOP内容？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      })
        .then(() => {
          this.list.splice(this.currentIndex, 1)
          this.currentIndex = 0
          // this.$forceUpdate()
        })
        .catch(function () {})
    },
    setCheckTimeFn() {
      // 天数、日期 --递增
      if (this.list.length > 1) {
        let arr = this.list.map((unit) => {
          return unit.pushTimePre
        })
        if (this.initData.businessType !== 5) {
          // 非客群周期营销
          let isSorted = arr.every((x, i) => i === 0 || x >= arr[i - 1])
          if (!isSorted) {
            this.msgError('发送时间顺序存在问题，请按照递增顺序选择天数或日期！')
            return false
          }
        } else {
          // 周日特殊 需放最后
          // if (arr.includes('1')) {
          //   if (arr.lastIndexOf('1') !== arr.length - 1) {
          //     //不在最后 所有不符合条件
          //     this.msgError('发送时间顺序存在问题，请按照递增顺序选择天数或日期！')
          //     return false
          //   } else {
          //     // 在最后  判断其他顺序
          //     //只存在一个周日
          //     if (arr.indexOf('1') == arr.lastIndexOf('1')) {
          //       arr = arr.filter((item) => {
          //         return item !== '1'
          //       })
          //       let isSorted = arr.every((x, i) => i === 0 || x >= arr[i - 1])
          //       if (!isSorted) {
          //         this.msgError('发送时间顺序存在问题，请按照递增顺序选择天数或日期！')
          //         return false
          //       }
          //     } else {
          //       // 多个周日
          //       let index = arr.indexOf('1')
          //       let pass = true
          //       for (index; index < arr.length; index++) {
          //         if (arr[index] !== '1') {
          //           pass = false
          //         }
          //       }
          //       if (!pass) {
          //         this.msgError('发送时间顺序存在问题，请按照递增顺序选择天数或日期！')
          //         return false
          //       }
          //     }
          //   }
          // } else {
          // }
          let isSorted = arr.every((x, i) => i === 0 || x >= arr[i - 1])
          if (!isSorted) {
            this.msgError('发送时间顺序存在问题，请按照递增顺序选择天数或日期！')
            return false
          }
        }
      }
      if (this.initData.sendType === 1) {
        // 天不能重复 企微群发
        let repeat = false
        let day = this.list.map((value) => value.pushTimePre)
        let daySet = new Set(day)
        if (daySet.size !== day.length) {
          repeat = true
          this.msgError('发送方式选项为【企微群发】时，天数日期不可重复!')
        }
        return !repeat
      } else {
        // 天可以重复  时间段不能交叉
        let result = false
        for (let i = 0; i < this.list.length; i++) {
          let arr = []
          this.list.forEach((unit, key) => {
            if (key !== i && this.list[i].pushTimePre === unit.pushTimePre) {
              arr.push(unit)
            }
          })
          result = this.checkTime(arr, this.list[i])
          if (result) {
            break
          }
        }
        if (result) {
          this.msgError('推送时间区间存在交叉，请检查调整！')
        }
        return !result
      }
    },
    checkTimePoint() {
      let result = false
      for (let i = 0; i < this.list.length; i++) {
        let arr = []
        this.list.forEach((unit, key) => {
          if (this.list[i].pushTimePre === unit.pushTimePre) {
            arr.push(unit)
          }
        })
        let isSorted = arr.every(
          (x, i) => i === 0 || this.tranDate(x.pushStartTime) >= this.tranDate(arr[i - 1].pushEndTime),
        )
        if (!isSorted) {
          this.msgError('发送时间顺序存在问题，请按照递增顺序选择时间区间')
          result = true
          break
        }
      }
      return !result
    },
    checkTime(arr, current) {
      let repeat = false
      arr.forEach((item, index) => {
        let state = this.compareTime(item.pushStartTime, item.pushEndTime, current.pushStartTime, current.pushEndTime)
        if (state) {
          repeat = true
        }
      })
      return repeat
    },
    compareTime(stime, etime, currentSTime, currentETime) {
      let startTime = this.tranDate(stime)
      let endTime = this.tranDate(etime)
      let nowSTime = this.tranDate(currentSTime)
      let nowETime = this.tranDate(currentETime)
      if (startTime === nowSTime && endTime === nowETime) {
        return true
      } else if (nowETime <= startTime) {
        return false
      } else if (nowSTime >= endTime) {
        return false
      } else {
        return true
      }
    },
    tranDate(time) {
      let s = ''
      let hour = 0
      let min = 0
      let sec = 0
      if (time.split(':')[0]) {
        hour = time.split(':')[0]
      }
      if (time.split(':')[1]) {
        min = time.split(':')[1]
      }
      if (time.split(':')[2]) {
        sec = time.split(':')[2]
      }
      s = Number(hour * 3600) + Number(min * 60) + Number(sec)
      return s
    },
  },
  created() {
    this.list = this.initData.weSopPushTimes
  },
}
</script>
<style lang="scss" scoped>
.unit {
  width: 550px;
  background: var(--bg-black-11);
  color: var(--font-black-5);
  border-radius: 6px 0 0 6px;
  font-size: 14px;
  cursor: pointer;
  &:hover {
    font-weight: 500;
    color: var(--font-black);
    // background: var(--color-light-10);
  }
  &:not(:last-child) {
    margin-bottom: 5px;
  }
}
.active {
  font-weight: 500;
  color: var(--font-black);
  background: var(--color-light-10);
}
.right_title {
  display: flex;
  justify-content: space-between;
  font-size: 14px;
  color: var(--color);
  font-weight: 600;
}
.operation_con {
  display: flex;
  justify-content: center;
}
</style>
