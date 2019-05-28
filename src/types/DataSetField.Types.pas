unit DataSetField.Types;

interface

type
  /// <summary>
  ///   Field types controlled by the API.
  /// </summary>
  TDataSetFieldType = (dfUnknown, dfJSONObject, dfJSONArray);

  TDataSetFieldTypeHelper = record helper for TDataSetFieldType
    function ToString: string;
  end;

implementation

{ TDataSetFieldTypeHelper }

function TDataSetFieldTypeHelper.ToString: string;
begin
  case Self of
    dfUnknown:
      Result := 'Unknown';
    dfJSONObject:
      Result := 'JSONObject';
    else
      Result := 'JSONArray';
  end;
end;

end.
