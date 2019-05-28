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
    /// <param name="DataSet">
    ///   It refers to the DataSet itself.
    /// </param>
    /// <param name="Owns">
    ///   Parameter responsible for indicating whether it's responsible for the destruction of the DataSet or not.
    /// </param>
    /// <returns>
    ///   Returns the IDataSetSerialize interface instance itself.
    /// </returns>
    function SetDataSet(const DataSet: TDataSet; const Owns: Boolean = False): IDataSetSerialize;
    /// <summary>
    ///   Responsible for defining the JSONObject and its owner.
    /// </summary>
    /// <param name="JSONObject">
    ///   It refers to the JSON itself.
    /// </param>
    /// <param name="Owns">
    ///   Parameter responsible for indicating whether it's responsible for the destruction of the JSON or not.
    /// </param>
    /// <returns>
    ///   Returns the IJSONSerialize interface instance itself.
    /// </returns>
    function SetJSONObject(const JSONObject: TJSONObject; const Owns: Boolean = False): IJSONSerialize;
    /// <summary>
    ///   Responsible for defining the JSONArray and its owner.
    /// </summary>
    /// <param name="JSONArray">
    ///   It refers to the JSON itself.
    /// </param>
    /// <param name="Owns">
    ///   Parameter responsible for indicating whether it's responsible for the destruction of the JSON or not.
    /// </param>
    /// <returns>
    ///   Returns the IJSONSerialize interface instance itself.
    /// </returns>
    function SetJSONArray(const JSONArray: TJSONArray; const Owns: Boolean = False): IJSONSerialize;
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

function TSerialize.SetDataSet(const DataSet: TDataSet; const Owns: Boolean = False): IDataSetSerialize;
begin
  Result := Self.DataSet.SetDataSet(DataSet, Owns);
end;

function TSerialize.SetJSONObject(const JSONObject: TJSONObject; const Owns: Boolean = False): IJSONSerialize;
begin
  Result := Self.JSON.SetJSONObject(JSONObject, Owns);
end;

function TSerialize.SetJSONArray(const JSONArray: TJSONArray; const Owns: Boolean = False): IJSONSerialize;
begin
  Result := Self.JSON.SetJSONArray(JSONArray, Owns);
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
