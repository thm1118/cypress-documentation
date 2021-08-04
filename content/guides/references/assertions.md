---
title: 断言
---

Cypress捆绑了流行的[Chai](/guides/references/assertions#Chai)断言库, 以及对[Sinon](/guides/references/assertions#Sinon-Chai) 和[jQuery](/guides/references/assertions#Chai-jQuery)的有益扩展, 免费为您带来数十个强大的断言.

<Alert type="info">

<strong class="alert-header">Cypress 新人?</strong>

本文档只是对Cypress支持的每个断言的参考引用。 

如果你想了解如何使用这些断言，请阅读我们的[Cypress简介](/guides/core-concepts/introduction-to-cypress#Assertions)指南中的断言.

</Alert>

## Chai

<Icon name="github"></Icon> [https://github.com/chaijs/chai](https://github.com/chaijs/chai)

### BDD 断言

这些Chainer可用于BDD断言 (`expect`/`should`). 列出的别名可以与它们原来的Chainer互换使用. 您可以在[这里](http://chaijs.com/api/bdd/) 看到可用的BDD Chai断言的整个列表.

| Chainer                                                                                                              | 例子                                                                                                                               |
| -------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| not                                                                                                                  | `expect(name).to.not.equal('Jane')`                                                                                                   |
| deep                                                                                                                 | `expect(obj).to.deep.equal({ name: 'Jane' })`                                                                                         |
| nested                                                                                                               | `expect({a: {b: ['x', 'y']}}).to.have.nested.property('a.b[1]')`<br>`expect({a: {b: ['x', 'y']}}).to.nested.include({'a.b[1]': 'y'})` |
| ordered                                                                                                              | `expect([1, 2]).to.have.ordered.members([1, 2]).but.not.have.ordered.members([2, 1])`                                                 |
| any                                                                                                                  | `expect(arr).to.have.any.keys('age')`                                                                                                 |
| all                                                                                                                  | `expect(arr).to.have.all.keys('name', 'age')`                                                                                         |
| a(_type_) <br><small class="aliases"><strong>Aliases: </strong>an</small>                                            | `expect('test').to.be.a('string')`                                                                                                    |
| include(_value_) <br><small class="aliases"><strong>Aliases: </strong>contain, includes, contains</small>            | `expect([1,2,3]).to.include(2)`                                                                                                       |
| ok                                                                                                                   | `expect(undefined).to.not.be.ok`                                                                                                      |
| true                                                                                                                 | `expect(true).to.be.true`                                                                                                             |
| false                                                                                                                | `expect(false).to.be.false`                                                                                                           |
| null                                                                                                                 | `expect(null).to.be.null`                                                                                                             |
| undefined                                                                                                            | `expect(undefined).to.be.undefined`                                                                                                   |
| exist                                                                                                                | `expect(myVar).to.exist`                                                                                                              |
| empty                                                                                                                | `expect([]).to.be.empty`                                                                                                              |
| arguments <br><small class="aliases"><strong>Aliases: </strong>Arguments</small>                                     | `expect(arguments).to.be.arguments`                                                                                                   |
| equal(_value_) <br><small class="aliases"><strong>Aliases: </strong>equals, eq</small>                               | `expect(42).to.equal(42)`                                                                                                             |
| deep.equal(_value_)                                                                                                  | `expect({ name: 'Jane' }).to.deep.equal({ name: 'Jane' })`                                                                            |
| eql(_value_) <br><small class="aliases"><strong>Aliases: </strong>eqls</small>                                       | `expect({ name: 'Jane' }).to.eql({ name: 'Jane' })`                                                                                   |
| greaterThan(_value_) <br><small class="aliases"><strong>Aliases: </strong>gt, above</small>                          | `expect(10).to.be.greaterThan(5)`                                                                                                     |
| least(_value_)<br><small class="aliases"><strong>Aliases: </strong>gte</small>                                       | `expect(10).to.be.at.least(10)`                                                                                                       |
| lessThan(_value_) <br><small class="aliases"><strong>Aliases: </strong>lt, below</small>                             | `expect(5).to.be.lessThan(10)`                                                                                                        |
| most(_value_) <br><small class="aliases"><strong>Aliases: </strong>lte</small>                                       | `expect('test').to.have.length.of.at.most(4)`                                                                                         |
| within(_start_, _finish_)                                                                                            | `expect(7).to.be.within(5,10)`                                                                                                        |
| instanceOf(_constructor_) <br><small class="aliases"><strong>Aliases: </strong>instanceof</small>                    | `expect([1, 2, 3]).to.be.instanceOf(Array)`                                                                                           |
| property(_name_, _[value]_)                                                                                          | `expect(obj).to.have.property('name')`                                                                                                |
| deep.property(_name_, _[value]_)                                                                                     | `expect(deepObj).to.have.deep.property('tests[1]', 'e2e')`                                                                            |
| ownProperty(_name_) <br><small class="aliases"><strong>Aliases: </strong>haveOwnProperty, own.property</small>       | `expect('test').to.have.ownProperty('length')`                                                                                        |
| ownPropertyDescriptor(_name_) <br><small class="aliases"><strong>Aliases: </strong>haveOwnPropertyDescriptor</small> | `expect({a: 1}).to.have.ownPropertyDescriptor('a')`                                                                                   |
| lengthOf(_value_)                                                                                                    | `expect('test').to.have.lengthOf(3)`                                                                                                  |
| match(_RegExp_) <br><small class="aliases"><strong>Aliases: </strong>matches</small>                                 | `expect('testing').to.match(/^test/)`                                                                                                 |
| string(_string_)                                                                                                     | `expect('testing').to.have.string('test')`                                                                                            |
| keys(_key1_, _[key2]_, _[...]_) <br><small class="aliases"><strong>Aliases: </strong>key</small>                     | `expect({ pass: 1, fail: 2 }).to.have.keys('pass', 'fail')`                                                                           |
| throw(_constructor_) <br><small class="aliases"><strong>Aliases: </strong>throws, Throw</small>                      | `expect(fn).to.throw(Error)`                                                                                                          |
| respondTo(_method_) <br><small class="aliases"><strong>Aliases: </strong>respondsTo</small>                          | `expect(obj).to.respondTo('getName')`                                                                                                 |
| itself                                                                                                               | `expect(Foo).itself.to.respondTo('bar')`                                                                                              |
| satisfy(_method_) <br><small class="aliases"><strong>Aliases: </strong>satisfies</small>                             | `expect(1).to.satisfy((num) => { return num > 0 })`                                                                                   |
| closeTo(_expected_, _delta_) <br><small class="aliases"><strong>Aliases: </strong>approximately</small>              | `expect(1.5).to.be.closeTo(1, 0.5)`                                                                                                   |
| members(_set_)                                                                                                       | `expect([1, 2, 3]).to.include.members([3, 2])`                                                                                        |
| oneOf(_values_)                                                                                                      | `expect(2).to.be.oneOf([1,2,3])`                                                                                                      |
| change(_function_) <br><small class="aliases"><strong>Aliases: </strong>changes</small>                              | `expect(fn).to.change(obj, 'val')`                                                                                                    |
| increase(_function_) <br><small class="aliases"><strong>Aliases: </strong>increases</small>                          | `expect(fn).to.increase(obj, 'val')`                                                                                                  |
| decrease(_function_) <br><small class="aliases"><strong>Aliases: </strong>decreases</small>                          | `expect(fn).to.decrease(obj, 'val')`                                                                                                  |

这些getter也可用于BDD断言。它们实际上什么也做不了，但它们能让你写出清晰的英语语句。

| 可链接的   getters                                                                           |
| ------------------------------------------------------------------------------------------- |
| `to`, `be`, `been`, `is`, `that`, `which`, `and`, `has`, `have`, `with`, `at`, `of`, `same` |

### TDD 断言

这些断言可用于TDD断言(`assert`).你可以在[这里](http://chaijs.com/api/assert/) 看到完整的Chai断言列表.

| 断言                                                        | 例子                                                |
| ----------------------------------------------------------- | ------------------------------------------------------ |
| .isOk(_object_, _[message]_)                                | `assert.isOk('everything', 'everything is ok')`        |
| .isNotOk(_object_, _[message]_)                             | `assert.isNotOk(false, 'this will pass')`              |
| .equal(_actual_, _expected_, _[message]_)                   | `assert.equal(3, 3, 'vals equal')`                     |
| .notEqual(_actual_, _expected_, _[message]_)                | `assert.notEqual(3, 4, 'vals not equal')`              |
| .strictEqual(_actual_, _expected_, _[message]_)             | `assert.strictEqual(true, true, 'bools strict eq')`    |
| .notStrictEqual(_actual_, _expected_, _[message]_)          | `assert.notStrictEqual(5, '5', 'not strict eq')`       |
| .deepEqual(_actual_, _expected_, _[message]_)               | `assert.deepEqual({ id: '1' }, { id: '1' })`           |
| .notDeepEqual(_actual_, _expected_, _[message]_)            | `assert.notDeepEqual({ id: '1' }, { id: '2' })`        |
| .isAbove(_valueToCheck_, _valueToBeAbove_, _[message]_)     | `assert.isAbove(6, 1, '6 greater than 1')`             |
| .isAtLeast(_valueToCheck_, _valueToBeAtLeast_, _[message]_) | `assert.isAtLeast(5, 2, '5 gt or eq to 2')`            |
| .isBelow(_valueToCheck_, _valueToBeBelow_, _[message]_)     | `assert.isBelow(3, 6, '3 strict lt 6')`                |
| .isAtMost(_valueToCheck_, _valueToBeAtMost_, _[message]_)   | `assert.isAtMost(4, 4, '4 lt or eq to 4')`             |
| .isTrue(_value_, _[message]_)                               | `assert.isTrue(true, 'this val is true')`              |
| .isNotTrue(_value_, _[message]_)                            | `assert.isNotTrue('tests are no fun', 'val not true')` |
| .isFalse(_value_, _[message]_)                              | `assert.isFalse(false, 'val is false')`                |
| .isNotFalse(_value_, _[message]_)                           | `assert.isNotFalse('tests are fun', 'val not false')`  |
| .isNull(_value_, _[message]_)                               | `assert.isNull(err, 'there was no error')`             |
| .isNotNull(_value_, _[message]_)                            | `assert.isNotNull('hello', 'is not null')`             |
| .isNaN(_value_, _[message]_)                                | `assert.isNaN(NaN, 'NaN is NaN')`                      |
| .isNotNaN(_value_, _[message]_)                             | `assert.isNotNaN(5, '5 is not NaN')`                   |
| .exists(_value_, _[message]_)                               | `assert.exists(5, '5 is not null or undefined')`       |
| .notExists(_value_, _[message]_)                            | `assert.notExists(null, 'val is null or undefined')`   |
| .isUndefined(_value_, _[message]_)                          | `assert.isUndefined(undefined, 'val is undefined')`    |
| .isDefined(_value_, _[message]_)                            | `assert.isDefined('hello', 'val has been defined')`    |
| .isFunction(_value_, _[message]_)                           | `assert.isFunction(x => x * x, 'val is func')`         |
| .isNotFunction(_value_, _[message]_)                        | `assert.isNotFunction(5, 'val not funct')`             |
| .isObject(_value_, _[message]_)                             | `assert.isObject({num: 5}, 'val is object')`           |
| .isNotObject(_value_, _[message]_)                          | `assert.isNotObject(3, 'val not object')`              |
| .isArray(_value_, _[message]_)                              | `assert.isArray(['unit', 'e2e'], 'val is array')`      |
| .isNotArray(_value_, _[message]_)                           | `assert.isNotArray('e2e', 'val not array')`            |
| .isString(_value_, _[message]_)                             | `assert.isString('e2e', 'val is string')`              |
| .isNotString(_value_, _[message]_)                          | `assert.isNotString(2, 'val not string')`              |
| .isNumber(_value_, _[message]_)                             | `assert.isNumber(2, 'val is number')`                  |
| .isNotNumber(_value_, _[message]_)                          | `assert.isNotNumber('e2e', 'val not number')`          |
| .isFinite(_value_, _[message]_)                             | `assert.isFinite('e2e', 'val is finite')`              |
| .isBoolean(_value_, _[message]_)                            | `assert.isBoolean(true, 'val is bool')`                |
| .isNotBoolean(_value_, _[message]_)                         | `assert.isNotBoolean('true', 'val not bool')`          |
| .typeOf(_value_, _name_, _[message]_)                       | `assert.typeOf('e2e', 'string', 'val is string')`      |
| .notTypeOf(_value_, _name_, _[message]_)                    | `assert.notTypeOf('e2e', 'number', 'val not number')`  |

## Chai-jQuery

<Icon name="github"></Icon> [https://github.com/chaijs/chai-jquery](https://github.com/chaijs/chai-jquery)

当断言DOM对象时，可以使用这些Chainers.

您通常会在使用DOM命令之后使用这些Chainers，例如: [`cy.get()`](/api/commands/get), [`cy.contains()`](/api/commands/contains), 等等

<!-- textlint-disable -->

| Chainers                | 断言                                                            |
| ----------------------- | -------------------------------------------------------------------- |
| attr(_name_, _[value]_) | `expect($el).to.have.attr('foo', 'bar')`                             |
| prop(_name_, _[value]_) | `expect($el).to.have.prop('disabled', false)`                        |
| css(_name_, _[value]_)  | `expect($el).to.have.css('background-color', 'rgb(0, 0, 0)')`        |
| data(_name_, _[value]_) | `expect($el).to.have.data('foo', 'bar')`                             |
| class(_className_)      | `expect($el).to.have.class('foo')`                                   |
| id(_id_)                | `expect($el).to.have.id('foo')`                                      |
| html(_html_)            | `expect($el).to.have.html('I love testing')`                         |
| text(_text_)            | `expect($el).to.have.text('I love testing')`                         |
| value(_value_)          | `expect($el).to.have.value('test@dev.com')`                          |
| visible                 | `expect($el).to.be.visible`                                          |
| hidden                  | `expect($el).to.be.hidden`                                           |
| selected                | `expect($option).not.to.be.selected`                                 |
| checked                 | `expect($input).not.to.be.checked`                                   |
| focus[ed]               | `expect($input).not.to.be.focused`<br>`expect($input).to.have.focus` |
| enabled                 | `expect($input).to.be.enabled`                                       |
| disabled                | `expect($input).to.be.disabled`                                      |
| empty                   | `expect($el).not.to.be.empty`                                        |
| exist                   | `expect($nonexistent).not.to.exist`                                  |
| match(_selector_)       | `expect($emptyEl).to.match(':empty')`                                |
| contain(_text_)         | `expect($el).to.contain('text')`                                     |
| descendants(_selector_) | `expect($el).to.have.descendants('div')`                             |

<!-- textlint-enable -->

## Sinon-Chai

<Icon name="github"></Icon> [https://github.com/domenic/sinon-chai](https://github.com/domenic/sinon-chai)

使用[`cy.stub()`](/api/commands/stub) 和 [`cy.spy()`](/api/commands/spy)在断言中使用这些Chainers。.

| Sinon.JS property/method | Assertion                                                               |
| ------------------------ | ----------------------------------------------------------------------- |
| called                   | `expect(spy).to.be.called`                                              |
| callCount                | `expect(spy).to.have.callCount(n)`                                      |
| calledOnce               | `expect(spy).to.be.calledOnce`                                          |
| calledTwice              | `expect(spy).to.be.calledTwice`                                         |
| calledThrice             | `expect(spy).to.be.calledThrice`                                        |
| calledBefore             | `expect(spy1).to.be.calledBefore(spy2)`                                 |
| calledAfter              | `expect(spy1).to.be.calledAfter(spy2)`                                  |
| calledWithNew            | `expect(spy).to.be.calledWithNew`                                       |
| alwaysCalledWithNew      | `expect(spy).to.always.be.calledWithNew`                                |
| calledOn                 | `expect(spy).to.be.calledOn(context)`                                   |
| alwaysCalledOn           | `expect(spy).to.always.be.calledOn(context)`                            |
| calledWith               | `expect(spy).to.be.calledWith(...args)`                                 |
| alwaysCalledWith         | `expect(spy).to.always.be.calledWith(...args)`                          |
| calledWithExactly        | `expect(spy).to.be.calledWithExactly(...args)`                          |
| alwaysCalledWithExactly  | `expect(spy).to.always.be.calledWithExactly(...args)`                   |
| calledWithMatch          | `expect(spy).to.be.calledWithMatch(...args)`                            |
| alwaysCalledWithMatch    | `expect(spy).to.always.be.calledWithMatch(...args)`                     |
| returned                 | `expect(spy).to.have.returned(returnVal)`                               |
| alwaysReturned           | `expect(spy).to.have.always.returned(returnVal)`                        |
| threw                    | `expect(spy).to.have.thrown(errorObjOrErrorTypeStringOrNothing)`        |
| alwaysThrew              | `expect(spy).to.have.always.thrown(errorObjOrErrorTypeStringOrNothing)` |

## 添加新断言

因为我们用的是`chai`，这意味着你可以随意扩展它.Cypress 与新添加到`chai`的断言“工作”。你可以:

- 写下你自己的`chai`断言 , [这里是文档](http://chaijs.com/api/plugins/).
- npm install 任意存在 `chai` 库， import 到你的测试文件或 support 文件内.

<Alert type="info">

[看看我们使用新断言扩展chai的示例配方.](/examples/examples/recipes#Fundamentals)

</Alert>

## 常见的断言

下面是常见元素断言的列表。注意我们如何使用[`.should()`](/api/commands/should) 中的这些断言(上面列出的). 您可能还想了解Cypress 如何[重试](/guides/core-concepts/retry-ability)断言。

### 长度

```javascript
// 重试直到找到3个<li.selected>的匹配项
cy.get('li.selected').should('have.length', 3)
```

### CSS 类

```javascript
// 重试，直到该输入没有禁用class
cy.get('form').find('input').should('not.have.class', 'disabled')
```

### 值

```javascript
// 重试，直到文本区域具有正确的value
cy.get('textarea').should('have.value', 'foo bar baz')
```

### 文本内容

```javascript
// 断言元素的文本内容就是给定的文本
cy.get('#user-name').should('have.text', 'Joe Smith')
// 断言元素的文本包含给定的子字符串
cy.get('#address').should('include.text', 'Atlanta')
// 重试，直到不包含'click me'
cy.get('a').parent('span.help').should('not.contain', 'click me')
// 元素的文本应该以“Hello”开始
cy.get('#greeting')
  .invoke('text')
  .should('match', /^Hello/)
// 提示:使用cy.contains查找元素及其文本
// 匹配给定的正则表达式
cy.contains('#a-greeting', /^Hello/)
```

**提示:** 在[如何获取元素的文本内容?](/faq/questions/using-cypress-faq#How-do-I-get-an-element-s-text-contents) 中阅读对具有不间断空格实体的文本的断言

### 可见性

```javascript
// 重试，直到id为"form-submit"的按钮可见
cy.get('button#form-submit').should('be.visible')
// 重试，直到列表项
// 可见文本“write tests”
cy.contains('.todo li', 'write tests').should('be.visible')
```

**注意:** 如果有多个元素，则断言`be.visible` 和 `not.be.visible`可见的行为不同:

```javascript
// 重试，直到某些元素可见为止
cy.get('li').should('be.visible')
// 重试，直到每个元素都不可见
cy.get('li.hidden').should('not.be.visible')
```

观看短视频[“多个元素和should('be.visible')断言”](https://www.youtube.com/watch?v=LxkrhUEE2Qk)  演示如何正确检查元素的可见性.

### 存在

```javascript
// 重试，直到加载菊花 不再存在
cy.get('#loading').should('not.exist')
```

### State

```javascript
// 在radio被选中前重试
cy.get(':radio').should('be.checked')
```

### CSS

```javascript
// 重试直到。completed有匹配的CSS
cy.get('.completed').should('have.css', 'text-decoration', 'line-through')
```

```javascript
// 重试直到 accordion的 CSS没有"display: none"属性
cy.get('#accordion').should('not.have.css', 'display', 'none')
```

### 禁用属性

```html
<input type="text" id="example-input" disabled />
```

```javascript
cy.get('#example-input')
  .should('be.disabled')
  // 让我们从测试中启用这个元素
  .invoke('prop', 'disabled', false)

cy.get('#example-input')
  // 我们可以使用“enabled”断言
  .should('be.enabled')
  //或否定“disabled”断言
  .and('not.be.disabled')
```

## 否定的断言

有肯定的，也有否定的断言. 正面断言的例子有:

```javascript
cy.get('.todo-item').should('have.length', 2).and('have.class', 'completed')
```

否定断言的前缀是“not”前缀. 否定断言的例子有:

```javascript
cy.contains('first todo').should('not.have.class', 'completed')
cy.get('#loading').should('not.be.visible')
```

#### ⚠️ 错误的通过测试

否定的断言可能会因为你意想不到的原因而通过. 假设我们想测试一个待办事项列表应用程序在输入待办事项并按enter键后添加了一个新的待办事项项目.

**正面断言**

当向列表中添加元素并使用正断言时, 测试断言我们应用程序中的Todo项的特定数量.

如果应用程序的行为意外，下面的测试可能仍然会错误地通过，比如添加一个空白的Todo，而不是添加带有文本“Write tests”的新Todo.

```javascript
cy.get('li.todo').should('have.length', 2)
cy.get('input#new-todo').type('Write tests{enter}')

// 使用正断言检查item的确切数量
cy.get('li.todo').should('have.length', 3)
```

**否定的断言**

但是，当在下面的测试中使用否定断言时，当应用程序以多种意想不到的方式行为时，测试可能会错误地通过:

- 该应用程序删除了整个待办事项列表，而不是插入第三个待办事项
- 该应用程序删除了一个待办事项，而不是添加一个新的待办事项
- 该应用程序添加了一个空白的待办事项
- 无限多种可能的应用程序错误

```javascript
cy.get('li.todo').should('have.length', 2)
cy.get('input#new-todo').type('Write tests{enter}')

// 使用否定断言来检查它是不是一个数值
cy.get('li.todo').should('not.have.length', 2)
```

**建议**

我们建议使用否定断言来验证在应用程序执行操作后某个特定条件 不再存在. 例如，当先前完成的项未选中时，我们可能会验证CSS类是否被删除.

```javascript
// 首先，这个项目被标记为completed
cy.contains('li.todo', 'Write tests')
  .should('have.class', 'completed')
  .find('.toggle')
  .click()

// CSS类已被删除
cy.contains('li.todo', 'Write tests').should('not.have.class', 'completed')
```

更多的例子，请阅读博客文章[小心否定断言](https://glebbahmutov.com/blog/negative-assertions/).

## Should 回调

如果内置断言还不够，您可以编写自己的断言函数，并将其作为回调传递给`.should()`命令。 Cypress将自动[重试](/guides/core-concepts/retry-ability)回调函数，直到它通过或命令超时. 查看 [`.should()`](/api/commands/should#Function) 文档.

```html
<div class="main-abc123 heading-xyz987">Introduction</div>
```

```javascript
cy.get('div').should(($div) => {
  expect($div).to.have.length(1)

  const className = $div[0].className

  // className将是一个像"main-abc123 heading-xyz987"这样的字符串
  expect(className).to.match(/heading-/)
})
```

## 多个断言

可以将多个断言附加到同一个命令。

```html
<a class="assertions-link active" href="https://on.cypress.io" target="_blank"
  >Cypress Docs</a
>
```

```js
cy.get('.assertions-link')
  .should('have.class', 'active')
  .and('have.attr', 'href')
  .and('include', 'cypress.io')
```

注意，所有链接的断言将使用对原始目标的相同引用. 例如，如果你想测试一个加载元素，它首先出现然后消失，下面的方法将不起作用，因为同一个元素不能同时可见和不可见:

```js
// ⛔️ 行不通
cy.get('#loading').should('be.visible').and('not.be.visible')
```

相反，您应该拆分断言并重新查询元素:

```js
// ✅ THE CORRECT WAY
cy.get('#loading').should('be.visible')
cy.get('#loading').should('not.be.visible')
```

## 另请参阅

- [断言指南:介绍Cypress](/guides/core-concepts/introduction-to-cypress#Assertions)
- [cypress-example-kitchensink 断言](https://example.cypress.io/commands/assertions)
- [Cypress should 回调](https://glebbahmutov.com/blog/cypress-should-callback/) blog post
