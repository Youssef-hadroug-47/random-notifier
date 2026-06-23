# random-notifier

## Description
> a random notification generator 

## Installation 
> [!NOTE]
> this app only works on linux mint

extract [file](https://github.com/Youssef-hadroug-47/random-notifier/releases/tag/release) content and run install.sh and there you are 

## Usage

```Usage
 notifier start [json-file]   Start the notification daemon
 notifier exit                Stop the running daemon
 notifier status              Show whether the daemon is running
 notifier logs                Show app logs


 Options for 'start':
   -h   usage guide

 Json Format Example

    {
        "interval":xxxx (default: 3600),
        "messages":[
            {
                "message":"xxxx" (default: Dhikr),
                "title":"xxxx" (default: Dhikr"),
                "urgency":"xxxx" (default: normal"),
                "sound":"Path/to/mp3" (default: "cinnamon default sound")
            },{
                ...
            }
        ]
    }

 Warning :   
   file name must be exactly "notifier.json"
   if you have a stored notifier.json you can just run notifier start

 Examples:
   notifier start  notifier.json
   notifier exit

```

## Useful Resources You Can Use
### Audio Example
   Here some [Audio](https://github.com/Youssef-hadroug-47/random-notifier/releases/tag/release) you can use in your notifier.json 
### Json Generator Script
   use this [script](https://github.com/Youssef-hadroug-47/random-notifier/releases/tag/release) to generate your notifier.json
   
   pass the audio assets directory path and run python json-generator.py /path/to/audio

```python
    import json
    import sys
    from pathlib import Path


    def generate_audio_json(target_directory):
        dir_path = Path(target_directory)

        if not dir_path.is_dir():
            print(f"Error: '{target_directory}' is not a valid directory.")
            sys.exit(1)

        audio_extensions = {
            ".mp3",
            ".wav",
            ".ogg",
            ".flac",
            ".m4a",
            ".aac",
            ".wma",
        }

        messages_list = []

        for file_path in dir_path.rglob("*"):
            if file_path.is_file() and file_path.suffix.lower() in audio_extensions:
                messages_list.append({"sound": str(file_path.resolve())})

        json_data = {"interval": 3600, "messages": messages_list}

        output_filename = "notifier.json"
        with open(output_filename, "w", encoding="utf-8") as json_file:
            json.dump(json_data, json_file, indent=4, ensure_ascii=False)

        print(
            f"Success! Found {len(messages_list)} audio files and saved them to '{output_filename}'."
        )


    if __name__ == "__main__":
        if len(sys.argv) != 2:
            print("Usage: python generate_json.py <directory_path>")
            sys.exit(1)

        generate_audio_json(sys.argv[1])
```



