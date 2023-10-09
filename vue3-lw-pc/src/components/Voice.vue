<script>
import BenzAMRRecorder from 'benz-amr-recorder'
let $isVoice = undefined
let $playRec = undefined
let $playRecSymbole = undefined
export default {
  name: 'Voice',
  props: {
    amrUrl: {
      type: String,
      default: '',
    },
  },
  data() {
    return {
      actived: false,
      // dialogVisible: false,
      // audioSrc: []
    }
  },
  computed: {},
  watch: {},
  created() {
    $isVoice || document.addEventListener('click', this.stop)
    $isVoice = true
  },
  mounted() {},
  methods: {
    play() {
      if (this.amrUrl) {
        if ($playRec) {
          if (this.stop(true)) {
            return
          }
        }
        $playRec = new BenzAMRRecorder()
        $playRecSymbole = this.amrUrl
        $playRec.initWithUrl(this.amrUrl).then(() => {
          this.actived = true
          $playRec.play()
          $playRec.onEnded(() => {
            this.actived = false
          })
          console.log('amr 时长：' + $playRec.getDuration())
        })
        // .catch((e) => {
        //   this.$message.error('播放录音失败，或文件损坏')
        // })
      } else {
        this.msgError('语音文件不存在')
      }
      // this.audioSrc = [JSON.parse(this.message.contact)[type]]
    },
    //停止播放
    stop(noset) {
      if ($playRec && $playRec.isPlaying()) {
        $playRec.stop()
        if (!noset || $playRecSymbole === this.amrUrl) {
          $playRecSymbole = ''
          return true
        }
      }
    },
    // close() {
    //   this.dialogVisible = false
    //   const mp3 = this.$refs.AudioPlayer
    //   mp3.pause()
    // },
    // onBeforePlay(next) {
    //   next() // 开始播放
    // }
  },
}
</script>

<template>
  <div>
    <el-icon-microphone :class="['el-icon-microphone cp', actived && 'actived']" @click.stop="play('attachment')" />
  </div>
</template>

<style lang="scss" scoped>
.el-icon-microphone {
  font-size: 40px;
  color: var(--color);
}
@keyframes play {
  from {
    // color: red;
  }
  to {
    color: red;
  }
}
.actived {
  animation: play 1s infinite alternate;
}
</style>
<style>
.message-right {
  .el-icon-microphone {
    color: inherit;
  }
}
</style>
