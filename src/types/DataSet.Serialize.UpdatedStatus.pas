unit DataSet.Serialize.UpdatedStatus;

interface

uses Data.DB;

type
  TUpdateStatusHelper = record helper for TUpdateStatus
    function ToString: string;
  end;

implementation

{ TUpdateStatusHelper }

function TUpdateStatusHelper.ToString: string;
begin
  case Self of
    usModified:
      Result := 'MODIFIED';
    usInserted:
      Result := 'INSERTED';
    usDeleted:
      Result := 'DELETED';
    else
      Result := 'UNOMODIFIED';
  end;
end;

end.
