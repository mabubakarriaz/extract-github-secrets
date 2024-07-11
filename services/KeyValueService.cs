using Microsoft.Azure.Cosmos.Table;
using extract_github_secrets.Models;
using System.Threading.Tasks;

namespace extract_github_secrets.Services
{
    public class KeyValueService
    {
        private readonly CloudTable _table;

        public KeyValueService(string storageConnectionString)
        {
            var storageAccount = CloudStorageAccount.Parse(storageConnectionString);
            var tableClient = storageAccount.CreateCloudTableClient(new TableClientConfiguration());
            _table = tableClient.GetTableReference("KeyValueTable");
            _table.CreateIfNotExists();
        }

        public async Task AddKeyValueRecordAsync(KeyValueRecord keyValueRecord)
        {
            var insertOperation = TableOperation.InsertOrReplace(keyValueRecord);
            await _table.ExecuteAsync(insertOperation);
        }

        public async Task<KeyValueRecord?> GetKeyValueRecordAsync(string key)
        {
            var retrieveOperation = TableOperation.Retrieve<KeyValueRecord>("KeyValuePartition", key);
            var result = await _table.ExecuteAsync(retrieveOperation);
            return result.Result as KeyValueRecord;
        }
    }
}
