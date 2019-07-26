unit DataSet.Serialize.JSON.Intf;

interface

uses System.JSON, Data.DB, Language.Types;

type
  IJSONSerialize = interface
    ['{5801BCC7-7720-4DF2-85F4-C8F69E2DC52C}']
    /// <summary>
    ///   Loads fields from a DataSet based on JSON.
    /// </summary>
    /// <param name="ADataSet">
    ///   Refers to the DataSet to which you want to load the structure.
    /// </param>
    procedure LoadStructure(const ADataSet: TDataSet);
    /// <summary>
    ///   Runs the merge between the record of DataSet and JSONObject.
    /// </summary>
    /// <param name="ADataSet">
    ///   Refers to the DataSet that you want to merge with the JSON object.
    /// </param>
    procedure Merge(const ADataSet: TDataSet);
    /// <summary>
    ///   Loads the DataSet with JSON content.
    /// </summary>
    /// <param name="ADataSet">
    ///   Refers to the DataSet you want to load.
    /// </param>
    procedure ToDataSet(const ADataSet: TDataSet);
    /// <summary>
    ///   Responsible for validating whether JSON has all the necessary information for a particular DataSet.
    /// </summary>
    /// <param name="ADataSet">
    ///   Refers to the DataSet that will be loaded with JSON.
    /// </param>
    /// <param name="ALang">
    ///   Language used to mount messages.
    /// </param>
    /// <returns>
    ///   Returns a JSONArray with the fields that were not informed.
    /// </returns>
    /// <remarks>
    ///   Walk the DataSet fields by checking the required property.
    ///   Uses the DisplayLabel property to mount the message.
    /// </remarks>
    function Validate(const ADataSet: TDataSet; const ALang: TLanguageType = enUS): TJSONArray;
    /// <summary>
    ///   Defines what the JSONObject.
    /// </summary>
    /// <param name="AJSONObject">
    ///   Refers to JSON itself.
    /// </param>
    /// <param name="AOwns">
    ///   Indicates the owner of the JSON.
    /// </param>
    /// <returns>
    ///   Returns the implementation of IJSONSerialize interface.
    /// </returns>
    /// <remarks>
    ///   If it's the owner destroys the same of the memory when finalizing.
    /// </remarks>
    function SetJSONObject(const AJSONObject: TJSONObject; const AOwns: Boolean = False): IJSONSerialize;
    /// <summary>
    ///   Defines what the JSONArray.
    /// </summary>
    /// <param name="AJSONArray">
    ///   Refers to JSON itself.
    /// </param>
    /// <param name="AOwns">
    ///   Indicates the owner of the JSON.
    /// </param>
    /// <returns>
    ///   Returns the implementation of IJSONSerialize interface.
    /// </returns>
    /// <remarks>
    ///   If it's the owner destroys the same of the memory when finalizing.
    /// </remarks>
    function SetJSONArray(const AJSONArray: TJSONArray; const AOwns: Boolean = False): IJSONSerialize;
  end;

implementation

end.
