//------------------------------------------------------------------------
//  Ready to Install page strings e.g.
//  VST3 Plugin will be installed to:
//    C:\....
//------------------------------------------------------------------------
#define VST3_STR "VST3"
#define VST3_PRESETS_STR VST3_STR + " Presets"
#define VST3_PLUGIN_STR VST3_STR + " Plugin"
#define WILL_BE_INSTALLED_TO_STR " will be installed to:"

function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo, MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;
 var
    cTemp: String;
begin
  if WizardIsComponentSelected('vst3plugin')
  then begin
    cTemp := cTemp + '{#VST3_PLUGIN_STR}' + '{#WILL_BE_INSTALLED_TO_STR}' + NewLine;
    cTemp := cTemp + Space + ExpandConstant('{commoncf64}\{#VST3_STR}') + NewLine + NewLine;
  end;
  
  if WizardIsComponentSelected('vst3presets')
  then begin
    cTemp := cTemp + '{#VST3_PRESETS_STR}' + '{#WILL_BE_INSTALLED_TO_STR}' + NewLine;
    cTemp := cTemp + Space + ExpandConstant('{commonappdata}\{#VST3_PRESETS_STR}') + NewLine + NewLine;
  end;

  Result := cTemp;
end;