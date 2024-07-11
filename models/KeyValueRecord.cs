using Microsoft.Azure.Cosmos.Table;

namespace extract_github_secrets.Models
{
    public class KeyValueRecord : TableEntity
    {
        public KeyValueRecord(string key, string value)
        {
            PartitionKey = "KeyValuePartition";
            RowKey = key;
            Value = value;
        }

        public KeyValueRecord() { }

        public string? Value { get; set; }
    }
}
