unit BooleanField.Types;

interface

type
  /// <summary>
  /// Boolean types handled by the API.
  /// </summary>
  TBooleanFieldType = (bfUnknown, bfBoolean, bfInteger);

  TBooleanFieldTypeHelpers = record helper for TBooleanFieldType
    function ToString: string;
  end;

implementation

{ TBooleanFieldTypeHelpers }

function TBooleanFieldTypeHelpers.ToString: string;
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
