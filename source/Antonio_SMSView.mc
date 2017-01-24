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
    
class MyNumberFactory extends Ui.PickerFactory {

    function getDrawable(item, isSelected) {
    	return new Ui.Text({:text=>item.toString(),
		:color=>Gfx.COLOR_WHITE,
		:font=>Gfx.FONT_NUMBER_THAI_HOT,
		:justification=>Gfx.TEXT_JUSTIFY_LEFT});
	}
		
	function getSize() { return 10; }
	function getValue(item) { return item;}
}

class MyPickerDelegate extends Ui.PickerDelegate {

	function onAccept(values) {
		for(var i = 0; i< values.size(); i++) {
			Sys.println(values[i]);
		}
		Ui.popView(Ui.SLIDE_DOWN);
		return true;
	}

	function onCancel( ) { return true; }
}

class MyInputDelegate extends Ui.BehaviorDelegate {

	function initialize() {
        Sys.println("Antonio - initialize");
        BehaviorDelegate.initialize();
    }
    
	function onSelect() {
        Sys.println("Antonio - onSelect");
		Ui.pushView(new Ui.Picker({:title=>new Ui.Text({:text=>"Picker"}),
			:pattern=>[new MyNumberFactory()],
			:defaults=>[0]}),
			new MyPickerDelegate(),
			Ui.SLIDE_UP );
		return true;
	}
}
