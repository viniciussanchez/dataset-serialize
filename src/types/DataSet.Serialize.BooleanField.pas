unit DataSet.Serialize.BooleanField;

{$IF DEFINED(FPC)}
{$MODE DELPHI}{$H+}
{$ENDIF}

interface

type
  /// <summary>
  /// Boolean types handled by the API.
  /// </summary>
  TBooleanFieldType = (bfUnknown, bfBoolean, bfInteger);

  TBooleanFieldTypeHelper = record helper for TBooleanFieldType
    function ToString: string;
  end;

implementation

function TBooleanFieldTypeHelper.ToString: string;
begin
  case Self of
    bfUnknown:
      Result := 'Unknown';
    bfBoolean:
      Result := 'Boolean';
    else
      Result := 'Integer';
  end;
end;

end.
