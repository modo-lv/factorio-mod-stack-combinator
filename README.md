# Stack Combinator

![GitHub release (latest by date)](https://img.shields.io/github/v/release/modo-lv/factorio-mod-stack-combinator?label=latest%20release)

A mod for [Factorio](http://factorio.com) that adds a new type of circuit network combinator to research and craft: a stack combinator. This combinator multiplies each input item signal it receives by that item's stack size. For example, if the stack size for Coal is 50 and you send a Coal signal with value 2, a stack combinator will output Coal×100.

## Features
* **Item signal *stackification***. Each item signal sent to the stack combinator input is output with its amount multiplied by that item's stack size. Non-item signals are output unchanged.
* **Signal inversion**. Each combinator can also be configured to *invert* input signals (green, red or both), which treats positive input signal amounts as negative and vice-versa. You can use this, for example, to keep track of the amount of items still needed to reach a full stack (or stacks) in a container: send a signal to an inverted input to indicate how many stacks of the item should be stored, and connect the container to the output. The combinator's negative output, together with the container's positive, will result in a negative difference (if there are less items than indicated), positive difference (if there are more than indicated) or 0 (if there are exactly as many full stacks of the item in the storage as indicated). Goes well with "item < 0" enabled/disabled condition on belts/inserters/etc.
* **Output signal display**. Opening the stack combinator shows all output signals, even if the combinator's output isn't connected to anything.
* **Vannila-like combinator interface**.

## Compatibility & balancing

* Works with **blueprints**.
* **Shouldn't break anything**. Stack combinator is based on the *arithmetic and constant combinators*, and does not involve any other entities or game objects.
* **Research costs** are calculated dynamically based on *circuit network* technology costs, so it should fit in naturally with balance changes introduced by other mods.
* **Crafting costs** are an *arithmetic combinator* and a *repair pack*.
* Can be **moved around with [Picker Dollies](https://mods.factorio.com/mod/PickerDollies)**.
* **Multiplayer** hasn't been tested, but the mod was written to function as close to the vanilla arithmetic combinator as possible, so it *should* be OK.
* Takes twice as long long to build in **expensive mode**.

## Limitations
* Due to the way game works, the **maximum amount of output signals** is initially limited to 20 (the signal capacity of the vanilla *constant combinator*). You can increase the limit in startup settings, but it may affect performance (according to [Larger Constant Combinator's changelog](https://mods.factorio.com/mod/Larger-Constant-Combinator/changelog); I haven't done any large-scale testing myself).
    * If a static combinator receives more signals than it can output, it won't output anything and raise an alert (so you can see on the map which combinators are having the problem and where).

## Discussion & bug reports
* The main dicussion and bug report place is [the mod's **discussion page**](https://mods.factorio.com/mod/stack-combinator/discussion).
* There's also a [thread on the forums](https://forums.factorio.com/viewtopic.php?f=190&t=94655). Do **not** report bugs there, bug report posts will be removed to prevent clutter.
* Bugs can be reported directly [on GitHub](http://github.com/modo-lv/factorio-mod-stack-combinator/issues), but other users are less likely to go there.
* A [Discord](https://discord.gg/K3aHYvak9M) also exists.

## Acknowledgements
This is my first serious mod ([Declutter](http://mods.factorio.com/mod/declutter) was a trivial couple of lines), and the mod that helped me figure out most of what I needed to get going was [Filter Combinator](https://mods.factorio.com/mod/Filter_Combinator) by [gcascaes](https://mods.factorio.com/user/gcascaes).