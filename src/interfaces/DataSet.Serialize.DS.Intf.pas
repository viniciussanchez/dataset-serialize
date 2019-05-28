unit DataSet.Serialize.DS.Intf;

interface

uses Data.DB, System.JSON;

type
  IDataSetSerialize = interface
    ['{6D79AF89-C94C-4E17-863C-F0E63FC2532A}']
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
    ///   Creates a JSON object with the data from the current record of DataSet.
    /// </summary>
    /// <returns>
    ///   Returns a JSON object containing the record data.
    /// </returns>
    /// <remarks>
    ///   Invisible fields will not be generated.
    /// </remarks>
    function ToJSONObject: TJSONObject;
    /// <summary>
    ///   Creates an array of JSON objects with all DataSet records.
    /// </summary>
    /// <returns>
    ///   Returns a JSONArray with all records from the DataSet.
    /// </returns>
    /// <remarks>
    ///   Invisible fields will not be generated.
    /// </remarks>
    function ToJSONArray: TJSONArray;
    /// <summary>
    ///   Responsible for exporting the structure of a DataSet in JSON Array format.
    /// </summary>
    /// <returns>
    ///   Returns a JSON array with all fields of the DataSet.
    /// </returns>
    /// <remarks>
    ///   Invisible fields will not be generated.
    /// </remarks>
    function SaveStructure: TJSONArray;
  end;

implementation

end.
