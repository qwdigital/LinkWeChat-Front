<script>
export default {
  name: '',
  components: {},
  data() {
    return {
      form: {},
      typeDict: {
        text: '文本',
        image: '图片',
        text: '图文',
        text: '视频',
        text: '文件',
      },
    }
  },
  computed: {},
  watch: {},
  created() {},
  mounted() {},
  methods: {},
}
</script>

<template>
  <div>
    <el-form
      style="width: 60%; margin: 0 auto"
      ref="form"
      :model="form"
      :rules="rules"
      label-width="100px">
      <div class="g-pad20">
        <div class="title">
          <span>消息设置</span>
          <span>将通过应用 【应用名称】 发送消息</span>
        </div>
        <el-form-item :label="typeTitle[type] + '标题'" prop="materialName" v-if="type === '4'">
          <el-input
            v-model="form.materialName"
            placeholder="请输入标题"
            maxlength="30"
            show-word-limit></el-input>
        </el-form-item>
        <el-form-item label="发送范围" required prop="pushRange">
          <el-radio-group v-model="form.pushRange">
            <el-radio :label="0">全部</el-radio>
            <el-radio :label="1">
              自定义
              <div v-if="form.pushRange == 1">
                <TagEllipsis :list="form.sendClientUserList" />
                <el-button
                  class="mr10"
                  size="mini"
                  icon="el-icon-circle-plus-outline"
                  type="primary"
                  plain
                  @click="onSelectUser(2)">
                  选择范围
                </el-button>
              </div>
            </el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="发送类型" required prop="isTask">
          <el-radio-group v-model="form.isTask">
            <el-radio :label="0">立即发送</el-radio>
            <el-radio :label="1">
              定时发送
              <div v-if="form.isTask == 1">
                <el-date-picker
                  v-model="form.sendTime"
                  type="datetime"
                  placeholder="选择日期时间"
                  :picker-options="pickerOptions"></el-date-picker>
              </div>
            </el-radio>
          </el-radio-group>
        </el-form-item>
      </div>

      <div class="g-pad20">
        <div class="title">消息设置</div>

        <el-form-item label="发送类型" required prop="isTask">
          <el-radio-group v-model="form.isTask">
            <el-radio v-for="(item, label, index) in typeDict" :key="index" :label="label">
              {{ item }}
            </el-radio>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="文本内容" prop="content" v-if="type === '4'">
          <el-input
            v-model="form.content"
            type="textarea"
            :autosize="{ minRows: 2, maxRows: 50 }"
            placeholder="请输入内容"
            maxlength="2000"
            show-word-limit
            @input="contentChange"></el-input>
        </el-form-item>

        <!-- 图片 -->
        <el-form-item label="图片" prop="materialUrl" v-else-if="type === '0'">
          <UploadToCos
            :fileUrl.sync="form.materialUrl"
            :fileName.sync="form.materialName"
            :maxSize="20"
            type="0"
            v-if="dialogVisible">
            <div slot="tip">支持jpg/jpeg/png格式，图片大小不超过2M</div>
          </UploadToCos>
        </el-form-item>

        <!-- 图文 -->
        <template v-else-if="type === '9'">
          <el-form-item label="图文地址" prop="materialUrl" :rules="rules.http">
            <el-input
              v-model="form.materialUrl"
              type="text"
              placeholder="请输入图文地址，以http://或https://开头"></el-input>
          </el-form-item>
          <el-form-item label="图文标题" prop="materialName">
            <el-input
              v-model="form.materialName"
              type="text"
              :maxlength="64"
              show-word-limit
              placeholder="请输入图文标题"></el-input>
          </el-form-item>
          <el-form-item label="图文描述">
            <el-input
              v-model="form.content"
              type="textarea"
              :maxlength="200"
              show-word-limit
              :autosize="{ minRows: 2, maxRows: 50 }"
              placeholder="请输入"></el-input>
          </el-form-item>
          <el-form-item label="图文封面">
            <UploadToCos :fileUrl.sync="form.coverUrl" type="0" v-if="dialogVisible">
              <div slot="tip">支持jpg/jpeg/png格式，建议200*200</div>
            </UploadToCos>
          </el-form-item>
        </template>

        <el-form-item v-else-if="type === '9'" label="上传视频" prop="materialUrl">
          <UploadToCos
            :fileUrl.sync="form.materialUrl"
            :fileName.sync="form.materialName"
            :type="type"
            @getPicUrl="getPicUrl"
            v-if="dialogVisible">
            <div slot="tip">支持mp4/mov格式，视频大小不超过100M</div>
          </UploadToCos>
        </el-form-item>

        <el-form-item v-else-if="type === '9'" label="上传文件" prop="materialUrl">
          <UploadToCos
            :fileUrl.sync="form.materialUrl"
            :fileName.sync="form.materialName"
            :type="type"
            v-if="dialogVisible"
            :isThree="true">
            <div slot="tip">支持pdf/ppt/word文件，单个文件大小不超过50M</div>
          </UploadToCos>
        </el-form-item>
        <template>
          <div></div>
        </template>
      </div>
    </el-form>
  </div>
</template>

<style lang="less" scoped></style>
