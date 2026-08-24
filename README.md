# Morse Code Translator

`mct` is a simple, fast, and memory-efficient command-line utility written in Zig. It provides a straightforward interface for translating plain text into standard Morse code and decoding Morse code back into text.

---

## Features

*   **Encode Text:** Quickly convert plain text into Morse code.
*   **Decode Morse:** Translate Morse code strings back into readable plain text.
*   **Simple CLI:** Easy-to-use interface with straightforward commands.
*   **Memory Efficient:** Built with Zig, leveraging safe and minimal memory allocation.

---

## Supported Characters & Formatting

The tool supports the following characters for translation:
*   **Letters:** `A-Z`, `a-z` (case-insensitive)
*   **Numbers:** `0-9`
*   **Punctuation:** `.` (period), `,` (comma), `?` (question mark), `/` (forward slash)

**Morse Code Formatting Rules:**
*   **Letters** within a word are separated by a single space (e.g., `HEI` becomes `.... . ..`).
*   **Words** are separated by a forward slash surrounded by spaces (e.g., `/ `). 

---

## Usage

The basic syntax for `mct` requires passing a command and the target message. If your message contains spaces, be sure to enclose it in quotes.

> **Syntax:** `mct [help | encode | decode] "{message}"`

**Available Commands:**
*   `encode` - Encodes `{message}` into Morse code.
*   `decode` - Decodes `{message}` from Morse code into text.
*   `help`   - Prints the standard usage and help menu.

**Examples:**

To encode a plain text message, use the `encode` command. Notice how the space between words is translated to a `/`:
```bash
$ mct encode "hello world"
.... . .-.. .-.. --- / .-- --- .-. .-.. -.. 
```

To decode a Morse code sequence back to text, use the `decode` command, ensuring you use `/` to represent spaces between words:

```bash
$ mct decode ".... . .-.. .-.. --- / .-- --- .-. .-.. -.."
hello world
```

To view the help menu at any time, simply run:

```bash
$ mct help
```

---

## Building from Source

To build this project, you will need the [Zig compiler](https://ziglang.org/download/) installed on your system.

1. Clone this repository to your local machine.
2. Navigate to the root directory of the project.
3. Build the executable using the standard Zig build command:
```bash
zig build -Doptimize=ReleaseSafe
```
4. Once compiled, you can find the `mct` binary located in the `zig-out/bin/` directory.
