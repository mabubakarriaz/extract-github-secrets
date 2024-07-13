using Microsoft.AspNetCore.Mvc;
using extract_github_secrets.Models;
using extract_github_secrets.Services;
using Microsoft.Extensions.Configuration;
using System.Threading.Tasks;

namespace extract_github_secrets.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KeyValueController : ControllerBase
    {
        private readonly KeyValueService _keyValueService;

        public KeyValueController(IConfiguration configuration)
        {
            var storageConnectionString = Environment.GetEnvironmentVariable("STORAGE_CONNECTION_STRING") ?? "";

            if (string.IsNullOrEmpty(storageConnectionString))
            {
                throw new ArgumentNullException(nameof(storageConnectionString));
            }

            _keyValueService = new KeyValueService(storageConnectionString);
        }

        [HttpPost]
        public async Task<ActionResult> PostKeyValueRecord([FromBody] KeyValueRecord keyValueRecord)
        {
            if (string.IsNullOrEmpty(keyValueRecord.RowKey) || string.IsNullOrEmpty(keyValueRecord.Value))
            {
                return BadRequest("Key and Value are required.");
            }

            keyValueRecord.PartitionKey = "KeyValuePartition";
            keyValueRecord.RowKey = keyValueRecord.RowKey;

            await _keyValueService.AddKeyValueRecordAsync(keyValueRecord);
            return Ok($"Saved key: {keyValueRecord.RowKey}, value: {keyValueRecord.Value}");
        }

        [HttpGet("{key}")]
        public async Task<ActionResult<KeyValueRecord>> GetKeyValueRecord(string key)
        {
            var keyValueRecord = await _keyValueService.GetKeyValueRecordAsync(key);

            if (keyValueRecord == null)
            {
                return NotFound($"No value found for key: {key}");
            }

            return Ok(keyValueRecord);
        }
    }
}
