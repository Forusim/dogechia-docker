<img src="https://dogechi.org/wp-content/uploads/2021/07/cropped-icon_256x256.png" width="100">

# DogeChia Docker Container
https://dogechi.org/

## Configuration
Required configuration:
* Publish network port via `-p 42069:42069`
* Bind mounting a host plot dir in the container to `/plots`  (e.g. `-v /path/to/hdd/storage/:/plots`)
* Bind mounting a host config dir in the container to `/root/.dogechia`  (e.g. `-v /path/to/storage/:/root/.dogechia`)
* Set initial `dogechia keys add` method:
  * Manual input from docker shell via `-e KEYS=type` (recommended)
  * Copy from existing farmer via `-e KEYS=copy` and `-e CA=/path/to/mainnet/config/ssl/ca/` 
  * Add key from mnemonic text file via `-e KEYS=/path/to/mnemonic.txt`
  * Generate new keys (default)

Optional configuration:
* Pass multiple plot directories via PATH-style colon-separated directories (.e.g. `-e plots_dir=/plots/01:/plots/02:/plots/03`)
* Set desired time zone via environment (e.g. `-e TZ=Europe/Berlin`)

On first start with recommended `-e KEYS=type`:
* Open docker shell `docker exec -it <containerid> sh`
* Enter `dogechia keys add`
* Paste space-separated mnemonic words
* Restart docker cotainer
* Enter `dogechia wallet show`
* Press `S` to skip restore from backup

## Operation
* Open docker shell `docker exec -it <containerid> sh`
* Check synchronization `dogechia show -s -c`
* Check farming `dogechia farm summary`
* Check balance `dogechia wallet show` 
