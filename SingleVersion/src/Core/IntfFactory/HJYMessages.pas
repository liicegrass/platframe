unit HJYMessages;

interface

ResourceString
  Err_ObjNotImpIntf = '对象%s未实现%s接口！';
  Err_DontUseTInterfacedObject = '不要用TObjFactory注册TInterfacedObject及其子类实现的接口！';
  Err_IntfExists = '接口%s已存在，不能重复注册！';
  Err_IntfNotSupport = '对象不支持%s接口！';
  Err_IIDsParamIsEmpty = 'TObjFactoryEx注册参数IIDs不能为空！';
  Err_IntfNotFound = '未找到%s接口！';
  Err_ModuleNotify = '处理Notify方法出错：%s';
  Err_InitModule = '处理模块Init方法出错(%s)，错误：%s';
  Err_ModuleNotExists = '找不到包[%s]，无法加载！';
  Err_LoadModule = '加载模块[%s]错误：%s';
  Err_finalModule = '模块[%s]final错误:%s';

  Msg_InitingModule = '正在初始化包[%s]';
  Msg_WaitingLogin = '正准备进入系统，请稍等...';
  Msg_LoadingModule = '正在加载包[%s]...';

implementation

end.
