unit dpm.dspec.replacer;

interface

uses
  System.SysUtils,
  System.RegularExpressions,
  DPM.Core.Types
  ;

type
  TClassReplacer = class
  private
    FCompiler : TCompilerVersion;
    function matcher(const Match: TMatch): String;
    function Replace(inputStr: string): string;
    constructor Create(compiler: TCompilerVersion);
  public
    class function ReplaceVars(inputStr: String; compiler: TCompilerVersion): string;
  end;


implementation

{ TClassReplacer }

constructor TClassReplacer.Create(compiler: TCompilerVersion);
begin
  FCompiler := compiler;
end;

function TClassReplacer.matcher(const Match: TMatch): String;
begin
  if SameText(Match.Groups[1].Value, 'compiler') then
    Exit(CompilerToString(FCompiler))
  else if SameText(Match.Groups[1].Value, 'compilerNoPoint') then
    Exit(CompilerToStringNoPoint(FCompiler))
  else if SameText(Match.Groups[1].Value, 'compilerCodeName') then
    Exit(CompilerCodeName(FCompiler))
  else if SameText(Match.Groups[1].Value, 'compilerWithCodeName') then
    Exit(CompilerWithCodeName(FCompiler))
  else if SameText(Match.Groups[1].Value, 'compilerVersion') then
    Exit(CompilerToCompilerVersionIntStr(FCompiler))
  else if SameText(Match.Groups[1].Value, 'libSuffix') then
    Exit(CompilerToLibSuffix(FCompiler))
  else if SameText(Match.Groups[1].Value, 'bdsVersion') then
    Exit(CompilerToBDSVersion(FCompiler))
  else
    Exit(Match.Value);  // In case of no match, return the original placeholder
end;

function TClassReplacer.Replace(inputStr: string): string;
begin
  Result := TRegEx.Replace(inputStr, '\$(.*?)\$', matcher);
end;

class function TClassReplacer.ReplaceVars(inputStr: String; compiler: TCompilerVersion): string;
var
  replacer : TClassReplacer;
begin
  replacer := TClassReplacer.Create(compiler);
  try
    Result := replacer.Replace(inputStr);
  finally
    FreeAndNil(replacer);
  end;
end;


end.
