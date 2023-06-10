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
    <el-icon-microphone
      :class="['el-icon-microphone', actived && 'actived']"
      style="font-size: 40px; color: var(--color)"
      @click.stop="play('attachment')" />

    <!-- <AudioPlayer
          :audio-list="audioSrc"
          ref="AudioPlayer"
          :before-play="onBeforePlay"
        /> -->
    <!-- <el-dialog v-if="audioSrc[0]"  v-model="dialogVisible" width="30%" @close="close">
      <div class="shabowboxvidoe shabowboxaudio">
        <audio controls>
          <source :src="audioSrc[0]" type="audio/mpeg" />
        </audio>
      </div>
      <span slot="footer" class="dialog-footer"> </span>
    </el-dialog> -->
  </div>
</template>

<style lang="scss" scoped>
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
