local LoginGameParam = class('LoginGameParam')

function LoginGameParam:ctor(logintype, param)
    self.logintype = logintype
    self.param = param
end 

function LoginGameParam:GetLoginType()
    return self.logintype
end 

function LoginGameParam:GetExtraParam()
    return self.param
end 
return LoginGameParam