<script setup>
import { getList, del } from './api'
import { ref } from 'vue'
let query = ref({})
let form = ref({})
let visible = ref(false)
</script>

<template>
  <div>
    <el-form :model="query" ref="queryForm" :inline="true" class="top-search" label-width="80px">
      <el-form-item label="请求地址" prop="url">
        <el-input v-model="query.url" placeholder="请输入" clearable />
      </el-form-item>
      <el-form-item label="请求时间" prop="groupLeaderName">
        <el-date-picker
          clearable
          v-model="query.dateRange"
          value-format="YYYY-MM-DD"
          type="daterange"
          v-bind="pickerOptions"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"></el-date-picker>
      </el-form-item>
      <SearchResetButton @search="$refs.table.getList(1)" @reset="$refs.queryForm.resetFields()"></SearchResetButton>
    </el-form>

    <RequestChartTable ref="table" :request="getList" :dealQueryFun="(params) => Object.assign(params, query)">
      <template #="{ data }">
        <el-table class="align-center" :data="data">
          <el-table-column label="请求地址" prop="url" width="500"></el-table-column>
          <el-table-column label="异常码" prop="errorCode"></el-table-column>
          <el-table-column label="异常信息" prop="errorMsg"></el-table-column>
          <el-table-column label="请求时间" prop="createTime"></el-table-column>
          <el-table-column label="操作">
            <template #default="{ row }">
              <el-button text @click=";(visible = true), Object.assign(form, row)">详情</el-button>
              <!-- <el-button text @click="$delConfirm(del.bind(row.groupId))">删除</el-button> -->
            </template>
          </el-table-column>
        </el-table>
      </template>
    </RequestChartTable>

    <el-dialog v-model="visible" title="详情">
      <el-form>
        <el-form-item label="参数:">
          {{ form.weParams }}
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<style lang="less" scoped></style>
