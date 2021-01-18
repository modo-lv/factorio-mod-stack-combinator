# Stack Combinator

![GitHub release (latest by date)](https://img.shields.io/github/v/release/modo_lv/factorio-mod-stack-combinator?label=latest%20release&style=plastic)

A mod for [Factorio](http://factorio.com) that adds a new type of circuit network combinator to research and craft.

A stack combinator multiplies each input item signal it receives by that item's stack size. For example, if the stack size for Coal is 50 and you send a Coal signal with value 2, a stack combinator will output 100.

## Features
* **Item signal *stackification***. Each item signal sent to the stack combinator input is output with its amount multiplied by that item's stack size. Non-item signals are be output unchanged.
* **Signal inversion**. Each combinator can also be configured to *invert* input signals (green, red or both), which treats positive input signal amounts as negative and vice-versa. You can use this, for example, to keep track of the amount of items still needed to reach a full stack (or stacks) in a container: send a signal to an inverted input to indicate how many stacks of the item should be stored, and connect the container to the output. The combinator's negative output, together with the container's positive, will result in a negative difference (if there are less items than indicated), positive difference (if there are more than indicated) or 0 (if there are exactly as many full stacks of the item in the storage as indicated). Goes well with "item < 0" enabled/disabled condition on belts/inserters/etc.
* **Output signal display**. Opening the stack combinator shows all output signals, even if the combinator's output isn't connected to anything.
* **Vannila-like combinator interface**.

## Compatibility & balancing

* Works with **blueprints**.
* **Shouldn't break anything**. Stack combinator is based on the Arithmetic Combinator and Constant Combinators, and does not involve any other entities or game objects.
* **Research costs** are calculated dynamically based on Circuit Network technology, so it should scale well with any balance changes introduced by other mods.
* **Crafting costs** are an Arithmetic Combinator and a Repair Pack.
* Can be **moved around with [Picker Dollies](https://mods.factorio.com/mod/PickerDollies)**.
* **Multiplayer** hasn't been tested, but the mod was written to function as close to the vanilla arithmetic combinator as possible, so it *should* be OK. If you encounter any bugs, please [report them on GitHub](http://github.com/modo-lv/factorio-mod-stack-combinator/issues)!
* Suppports **expensive mode**.