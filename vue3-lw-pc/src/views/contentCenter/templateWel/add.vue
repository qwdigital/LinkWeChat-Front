<template>
  <div>
    <!-- iswelcom:是否为欢迎语模板;-->
    <AddMaterial
      :tplType="tplType"
      :templateType="templateType"
      :iswelcom="true"
      :modelId="modelId"
      :moduleType="3"
    />
  </div>
</template>

<script>
import AddMaterial from '@/components/ContentCenter/AddMaterial.vue'
export default {
  components: {
    AddMaterial,
  },
  data() {
    return {
      tplType: undefined,
      templateType: 1,
      modelId: undefined,
    }
  },
  created() {
    this.tplType = this.$route.query.tplType
    this.modelId = this.$route.query.id
  },
}
</script>

<style></style>
