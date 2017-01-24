using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;

class Antonio_SMSView extends Ui.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        Sys.println("Antonio - onLayout");
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }
}


class MyInputDelegate extends Ui.BehaviorDelegate {

	function initialize() {
        Sys.println("Antonio - initialize");
        BehaviorDelegate.initialize();
    }
    
	function onSelect() {
        Sys.println("Antonio - onSelect");
        var factory = new WordFactory(["Lori", "Dave", "Tim"], {:font=>Gfx.FONT_MEDIUM});
		Ui.pushView(new Ui.Picker({:title=>new Ui.Text({:text=>"SMS Picker", :locX =>Ui.LAYOUT_HALIGN_CENTER}),
			:pattern=>[factory],
			:defaults=>[0]}),
			new MyPickerDelegate(),
			Ui.SLIDE_UP);
		return true;
	}
	
	function onCancel() {
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}

class MyPickerDelegate extends Ui.PickerDelegate {

	function onAccept(values) {
		for(var i = 0; i < values.size(); i++) {
			Sys.println(values[i]);
		}
		Ui.popView(Ui.SLIDE_DOWN);
		return true;
	}

	function onCancel( ) { return true; }
}

class WordFactory extends Ui.PickerFactory {
    var mWords;
    var mFont;

    function initialize(words, options) {
        PickerFactory.initialize();

        mWords = words;
        if (options != null) { mFont = options.get(:font); }
        if (mFont == null)   { mFont = Gfx.FONT_LARGE; }
    }

    function getIndex(value) {
        if (value instanceof String) {
            for(var i = 0; i < mWords.size(); ++i) {
                if(value.equals(Ui.loadResource(mWords[i]))) { return i; }
            }
        } else {
            for (var i = 0; i < mWords.size(); ++i) {
                if (mWords[i].equals(value)) { return i; }
            }
        }
        return 0;
    }

    function getSize() {
        return mWords.size();
    }

    function getValue(index) {
        return mWords[index];
    }

    function getDrawable(index, selected) {
        return new Ui.Text({:text=>mWords[index], :color=>Gfx.COLOR_WHITE, :font=>mFont, :locX=>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_CENTER});
    }
}
