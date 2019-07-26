unit DataSet.Serialize.Impl;

interface

uses DataSet.Serialize.Intf, DataSet.Serialize.DS.Intf, Data.DB, System.JSON, DataSet.Serialize.JSON.Intf;

type
  TSerialize = class(TInterfacedObject, ISerialize)
  protected
    /// <summary>
    ///   Responsible for creating an instance of the IJSONSerialize interface.
    /// </summary>
    /// <returns>
    ///  Returns the IJSONSerialize interface instance.
    /// </returns>
    function JSON: IJSONSerialize;
    /// <summary>
    ///   Responsible for creating an instance of the IDataSetSerialize interface.
    /// </summary>
    /// <returns>
    ///  Returns the IDataSetSerialize interface instance.
    /// </returns>
    function DataSet: IDataSetSerialize;
    /// <summary>
    ///   Responsible for defining the DataSet and its owner.
    /// </summary>
    /// <param name="ADataSet">
    ///   It refers to the DataSet itself.
    /// </param>
    /// <param name="AOwns">
    ///   Parameter responsible for indicating whether it's responsible for the destruction of the DataSet or not.
    /// </param>
    /// <returns>
    ///   Returns the IDataSetSerialize interface instance itself.
    /// </returns>
    function SetDataSet(const ADataSet: TDataSet; const AOwns: Boolean = False): IDataSetSerialize;
    /// <summary>
    ///   Responsible for defining the JSONObject and its owner.
    /// </summary>
    /// <param name="AJSONObject">
    ///   It refers to the JSON itself.
    /// </param>
    /// <param name="AOwns">
    ///   Parameter responsible for indicating whether it's responsible for the destruction of the JSON or not.
    /// </param>
    /// <returns>
    ///   Returns the IJSONSerialize interface instance itself.
    /// </returns>
    function SetJSONObject(const AJSONObject: TJSONObject; const AOwns: Boolean = False): IJSONSerialize;
    /// <summary>
    ///   Responsible for defining the JSONArray and its owner.
    /// </summary>
    /// <param name="AJSONArray">
    ///   It refers to the JSON itself.
    /// </param>
    /// <param name="AOwns">
    ///   Parameter responsible for indicating whether it's responsible for the destruction of the JSON or not.
    /// </param>
    /// <returns>
    ///   Returns the IJSONSerialize interface instance itself.
    /// </returns>
    function SetJSONArray(const AJSONArray: TJSONArray; const AOwns: Boolean = False): IJSONSerialize;
  public
    /// <summary>
    ///   Creates a new instance of ISerialize interface.
    /// </summary>
    /// <returns>
    ///   Returns an instance of ISerialize interface.
    /// </returns>
    class function New: ISerialize; static;
  end;

implementation

uses DataSet.Serialize.DS.Impl, DataSet.Serialize.JSON.Impl;

{ TSerialize }

function TSerialize.SetDataSet(const ADataSet: TDataSet; const AOwns: Boolean = False): IDataSetSerialize;
begin
  Result := Self.DataSet.SetDataSet(ADataSet, AOwns);
end;

function TSerialize.SetJSONObject(const AJSONObject: TJSONObject; const AOwns: Boolean = False): IJSONSerialize;
begin
  Result := Self.JSON.SetJSONObject(AJSONObject, AOwns);
end;

function TSerialize.SetJSONArray(const AJSONArray: TJSONArray; const AOwns: Boolean = False): IJSONSerialize;
begin
  Result := Self.JSON.SetJSONArray(AJSONArray, AOwns);
end;

function TSerialize.DataSet: IDataSetSerialize;
begin
  Result := TDataSetSerialize.New;
end;

function TSerialize.JSON: IJSONSerialize;
begin
  Result := TJSONSerialize.New;
end;

class function TSerialize.New: ISerialize;
begin
  Result := TSerialize.Create;
end;

end.
