# Switchy
**Switchy** is the fastest way to work in **Roblox Studio** and **Any Code Editor**.

Switchy emulates native Roblox Studio functionality of Play/Stop keybindings with any code editor, accelerating your development workflow.

## Key Features

- **Run Your Game Instantly**  
  Press ANY key to run your game and switch tabs to Roblox Studio.
  
- **Return to Scripting with Ease**  
  Press ANY key to stop the game and immediately switch back to your Code Editor for scripting.

> [!CAUTION]
> Switchy is only available on Windows operating systems at this time.
> Switchy is currently in the early stages of development!

## Why Use Switchy?

- **Boost Productivity**: No more constant alt-tabbing between windows.
- **Stay Focused**: Seamless switching keeps you in flow.
- **Native Experience**: Win32 keybindings make Switchy *blazingly fast*.

## Installation From Rokit or Aftman
- Make sure you have Rokit or Aftman installed
- Then run the following command using either Rokit or Aftman 
  ```bash
  Rokit add spomge/Switchy
  ```
- Usage Syntax
  ```bash
  Switchy "[Roblox Studio Window Title]" "[Visual Studio Code / Cursor]" "[Key to switch to Roblox Studio]" "[Key to switch to Visual Studio Code / Cursor]"
  ```
- Example Usage
  ```bash
  Switchy "YourGameNameHere - Roblox Studio" "Visual Studio Code" "F5" "F4"
  ```

## Installation From Source

- Clone the repository:
   ```bash
   git clone https://github.com/spomge/switchy.git
   ```

- Install Zig:
    if you don't have zig installed, or you don't have 0.13.0 installed, you can install it [here](https://ziglang.org/download/)!

- Build the project: 
    To build the project all you need to do is run `zig build` from the root of the project!

- Usage Syntax
   ```bash
   zig build run -- "[Roblox Studio Window Title]" "[Visual Studio Code / Cursor]" "[Key to siwtch to Roblox Studio]" "[Key to switch to Visual Studio Code / Cursor]"
   ```

- Example Usage
   ```bash
   zig build run -- "MyGame - Roblox Studio" "Visual Studio Code" "F5" "F4"
   ```
    This listens for F5 and switchs to Roblox and plays the game. On F4 it switches back to VSC.
    

## License

This project is licensed under the MIT License.
