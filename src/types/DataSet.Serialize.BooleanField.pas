unit DataSet.Serialize.BooleanField;

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

{ TBooleanFieldTypeHelper }

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
