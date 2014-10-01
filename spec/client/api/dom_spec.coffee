describe "Dom Command API", ->
  beforeEach ->
    @emit = @sandbox.stub(Eclectus.Command.prototype, "emit").returns(null)

    loadFixture("html/dom").progress (iframe) =>
      Eclectus.patch {contentWindow: iframe.contentWindow}
      @dom = Eclectus.createDom {contentWindow: iframe.contentWindow}
      @contentWindow = iframe.contentWindow

  it "stores the iframe's document", ->
    expect(@dom.document).to.eq @contentWindow.document

  it "uses '$' to reference the iframe document", ->
    el = @dom.$("#dom")[0]
    el2 = $("iframe").contents().find("#dom")[0]
    expect(el).to.eq el2

  describe "#find", ->
    beforeEach ->
      @dom.find "#dom"

    it "sets $el to the parent $", ->
      delete @contentWindow.jQuery
      @dom = Eclectus::find "#dom"
      expect(@dom.$el).to.be.instanceof($)

    it "sets $el to the iframe $ if it exists", ->
      @dom = Eclectus::find "#dom"
      expect(@dom.$el).to.be.instanceof @contentWindow.$

    it "sets _$el to the parent jquery instance", ->
      expect(@dom._$el).to.exist

    it "sets length", ->
      expect(@dom.length).to.eq @dom.$el.length

    it "sets selector to the first argument", ->
      expect(@dom.selector).to.eq "#dom"

    it "sets error when $el cannot be found", ->
      dom = @dom.find("#foobarbaz")
      expect(dom).to.have.property("error")

    context "chaining #find off of existing Dom instance", ->
      beforeEach ->
        @dom2 = @dom.find("#nested-find")

      it "returns a new Dom instance", ->
        expect(@dom2).not.to.eq @dom

      it "sets the prevObject of dom2 to dom", ->
        expect(@dom2.prevObject).to.eq @dom

      it "sets _$el to the parent jquery instance", ->
        expect(@dom2._$el).to.exist

  describe "#within", ->
    beforeEach ->
      @dom = Eclectus::within "#dom", =>
        @dom2 = Eclectus::find "#nested-find"
        @dom3 = Eclectus::within "#list", =>
          @dom4 = Eclectus::find "li"

    it "sets $el to the parent $", ->
      delete @contentWindow.jQuery
      @dom = Eclectus::within "#dom", =>
      expect(@dom.$el).to.be.instanceof($)

    it "sets $el to the iframe $ if it exists", ->
      expect(@dom.$el).to.be.instanceof @contentWindow.$

    it "sets _$el to the parent jquery instance", ->
      expect(@dom._$el).to.exist

    it "finds the child _$el", ->
      expect(@dom2._$el[0]).to.eq @contentWindow.$("#nested-find")[0]

    it "sets length", ->
      expect(@dom.length).to.eq @dom.$el.length

    it "sets selector to the first argument", ->
      expect(@dom.selector).to.eq "#dom"

    context "nested method within (#within)", ->
      it "sets prevObject of dom2 to dom", ->
        expect(@dom2.prevObject).to.eq @dom

    context "double within", ->
      beforeEach ->
        @dom = Eclectus::within "#dom", =>
          @dom2 = Eclectus::within "#list", =>
            @dom3 = Eclectus::find "li"

      it "sets dom3 prevObject to dom2", ->
        expect(@dom3.prevObject).to.eq @dom2

      it "sets _$el to the parent jquery instance", ->
        expect(@dom2._$el).to.exist

      it "finds the child _$el", ->
        expect(@dom2._$el[0]).to.eq @contentWindow.$("#list")[0]

  describe "action methods", ->
    context "#type", ->
      beforeEach ->
        @input = @dom.find("#input")
        @type = @input.type "foo"

      it "instantiates a new instance", ->
        expect(@type).not.to.eq @input

      it "sets the prevObject", ->
        expect(@type.prevObject).to.eq @input

      describe "nested #type", ->
        it "sets the parent to the original $el", ->
          @emit.restore()
          @type2 = @type.type("bar")
          expect(@type2._parent).to.eq @input.id

    context "#click", ->
      beforeEach ->
        @button = @dom.find("#button")
        @click = @button.click()

      it "instantiates a new instance", ->
        expect(@click).not.to.eq @button

      it "does not set an error (obviously)", ->
        expect(@click).not.to.have.property("error")

      describe "nested #click", ->
        it "sets parent to the original instance id", ->
          @emit.restore()
          @click2 = @click.click()
          expect(@click2._parent).to.eq @button.id

        it "stores a reference to the original $el", ->
          @click2 = @click.click()
          expect(@click2.$el).to.eq @button.$el

        it "throws an error when the $el is removed from the DOM", ->
          @click.$el.remove()
          @click2 = @click.click()
          expect(@click2).to.have.property("error")

  describe "traversal methods", ->
    it "throws if calling these methods directly"

    context "#eq", ->
      beforeEach ->
        @eq = @dom.find("#list li").eq(0)
        @eq.snapshot = @eq.getSnapshot()

      it "returns a new dom instance", ->
        expect(@eq).not.to.eq @dom

      it "sets the prevObject dom instance", ->
        expect(@eq.prevObject).to.eq @dom

      it "sets selector to 0", ->
        expect(@eq.selector).to.eq 0

      it "sets length to 1", ->
        expect(@eq.length).to.eq 1

      it "sets $el to the first li", ->
        li = $("iframe").contents().find("#list li").eq(0)[0]
        expect(@eq.$el[0]).to.eq li

      it "sets the dom", ->
        expect(@eq.snapshot).to.be.instanceof($)

      it "allows the el to be findable in the stored dom", ->
        li = @eq.snapshot.find("[data-eclectus-el]")
        expect(li).to.have.prop "nodeName", "LI"

      it "removes the special data-eclectus-el selector from $el", ->
        expect(@eq.$el).not.to.have.attr "data-eclectus-el"
