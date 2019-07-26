unit DataSet.Serialize.Intf;

interface

uses DataSet.Serialize.DS.Intf, Data.DB, System.JSON, DataSet.Serialize.JSON.Intf;

type
  ISerialize = interface
    ['{EFA88F05-4588-47EF-AB6A-DF15A430A0E1}']
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
    function SetJSONObject(const AJSONObject: TJSONObject;  const AOwns: Boolean = False): IJSONSerialize;
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
  end;

implementation

end.
