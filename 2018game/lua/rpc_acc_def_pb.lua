-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf"
module('rpc_acc_def_pb', package.seeall)
local pb_table = {}

pb_table.LOGOUTREASON = protobuf.EnumDescriptor();
pb_table.LOGOUTREASON_LR_NORMAL_ENUM = protobuf.EnumValueDescriptor();
pb_table.LOGOUTREASON_LR_REPEATEDLOGIN_ENUM = protobuf.EnumValueDescriptor();
pb_table.S2C_LOGOUT = protobuf.Descriptor();
pb_table.S2C_LOGOUT_ACCOUNTID_FIELD = protobuf.FieldDescriptor();
pb_table.S2C_LOGOUT_DEVICETYPE_FIELD = protobuf.FieldDescriptor();
pb_table.S2C_LOGOUT_REASON_FIELD = protobuf.FieldDescriptor();

pb_table.LOGOUTREASON_LR_NORMAL_ENUM.name = "LR_Normal"
pb_table.LOGOUTREASON_LR_NORMAL_ENUM.index = 0
pb_table.LOGOUTREASON_LR_NORMAL_ENUM.number = 0
pb_table.LOGOUTREASON_LR_REPEATEDLOGIN_ENUM.name = "LR_RepeatedLogin"
pb_table.LOGOUTREASON_LR_REPEATEDLOGIN_ENUM.index = 1
pb_table.LOGOUTREASON_LR_REPEATEDLOGIN_ENUM.number = 1
pb_table.LOGOUTREASON.name = "LogoutReason"
pb_table.LOGOUTREASON.full_name = ".rpc.LogoutReason"
pb_table.LOGOUTREASON.values = {pb_table.LOGOUTREASON_LR_NORMAL_ENUM,pb_table.LOGOUTREASON_LR_REPEATEDLOGIN_ENUM}
pb_table.S2C_LOGOUT_ACCOUNTID_FIELD.name = "accountID"
pb_table.S2C_LOGOUT_ACCOUNTID_FIELD.full_name = ".rpc.S2C_Logout.accountID"
pb_table.S2C_LOGOUT_ACCOUNTID_FIELD.number = 1
pb_table.S2C_LOGOUT_ACCOUNTID_FIELD.index = 0
pb_table.S2C_LOGOUT_ACCOUNTID_FIELD.label = 2
pb_table.S2C_LOGOUT_ACCOUNTID_FIELD.has_default_value = false
pb_table.S2C_LOGOUT_ACCOUNTID_FIELD.default_value = ""
pb_table.S2C_LOGOUT_ACCOUNTID_FIELD.type = 9
pb_table.S2C_LOGOUT_ACCOUNTID_FIELD.cpp_type = 9

pb_table.S2C_LOGOUT_DEVICETYPE_FIELD.name = "deviceType"
pb_table.S2C_LOGOUT_DEVICETYPE_FIELD.full_name = ".rpc.S2C_Logout.deviceType"
pb_table.S2C_LOGOUT_DEVICETYPE_FIELD.number = 2
pb_table.S2C_LOGOUT_DEVICETYPE_FIELD.index = 1
pb_table.S2C_LOGOUT_DEVICETYPE_FIELD.label = 2
pb_table.S2C_LOGOUT_DEVICETYPE_FIELD.has_default_value = false
pb_table.S2C_LOGOUT_DEVICETYPE_FIELD.default_value = 0
pb_table.S2C_LOGOUT_DEVICETYPE_FIELD.type = 5
pb_table.S2C_LOGOUT_DEVICETYPE_FIELD.cpp_type = 1

pb_table.S2C_LOGOUT_REASON_FIELD.name = "reason"
pb_table.S2C_LOGOUT_REASON_FIELD.full_name = ".rpc.S2C_Logout.reason"
pb_table.S2C_LOGOUT_REASON_FIELD.number = 3
pb_table.S2C_LOGOUT_REASON_FIELD.index = 2
pb_table.S2C_LOGOUT_REASON_FIELD.label = 2
pb_table.S2C_LOGOUT_REASON_FIELD.has_default_value = false
pb_table.S2C_LOGOUT_REASON_FIELD.default_value = nil
pb_table.S2C_LOGOUT_REASON_FIELD.enum_type = pb_table.LOGOUTREASON
pb_table.S2C_LOGOUT_REASON_FIELD.type = 14
pb_table.S2C_LOGOUT_REASON_FIELD.cpp_type = 8

pb_table.S2C_LOGOUT.name = "S2C_Logout"
pb_table.S2C_LOGOUT.full_name = ".rpc.S2C_Logout"
pb_table.S2C_LOGOUT.nested_types = {}
pb_table.S2C_LOGOUT.enum_types = {}
pb_table.S2C_LOGOUT.fields = {pb_table.S2C_LOGOUT_ACCOUNTID_FIELD, pb_table.S2C_LOGOUT_DEVICETYPE_FIELD, pb_table.S2C_LOGOUT_REASON_FIELD}
pb_table.S2C_LOGOUT.is_extendable = false
pb_table.S2C_LOGOUT.extensions = {}

LR_Normal = 0
LR_RepeatedLogin = 1
S2C_Logout = protobuf.Message(pb_table.S2C_LOGOUT)

_G["RPC_ACC_DEF_PB_LOGOUTREASON"] = pb_table.LOGOUTREASON
_G["RPC_ACC_DEF_PB_S2C_LOGOUT"] = pb_table.S2C_LOGOUT
