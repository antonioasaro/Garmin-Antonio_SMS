using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.Communications as Comm;
var name, msg;
var showNames = true;

class Antonio_SMSView extends Ui.View {
	
    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        Sys.println("Antonio - onLayout");
        showNames = true;
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


class NameInputDelegate extends Ui.BehaviorDelegate {
	
	function initialize() {
		BehaviorDelegate.initialize();
    }
    
	function onSelect() {
        Sys.println("Antonio - onSelect");
        var nameFactory = new WordFactory(["Lori", "Dave", "Tim"], {:font=>Gfx.FONT_LARGE});
		Ui.pushView(new Ui.Picker({:title=>new Ui.Text({:text=>"Name Picker", :locX =>Ui.LAYOUT_HALIGN_CENTER}), :pattern=>[nameFactory], :defaults=>[0]}),	new NamePickerDelegate(), Ui.SLIDE_UP);
		return true;
	}
}

class NamePickerDelegate extends Ui.PickerDelegate {

	function onAccept(values) {
        Sys.println("Antonio - onAcceptN");
		for(var i = 0; i < values.size(); i++) { name = values[i]; Sys.println(name); }
		Ui.popView(Ui.SLIDE_DOWN);
        var msgFactory = new WordFactory(["Yes", "No"          ], {:font=>Gfx.FONT_LARGE}); 
   	    Ui.pushView(new Ui.Picker({:title=>new Ui.Text({:text=>"Msg Picker", :locX =>Ui.LAYOUT_HALIGN_CENTER}), :pattern=>[msgFactory], :defaults=>[0]}), new MsgPickerDelegate(), Ui.SLIDE_UP);		
		return true;
	}
	
	function onCancel() {
        Sys.println("Antonio - onCancelN");
		Ui.popView(Ui.SLIDE_DOWN);
		return true;
	}
}

class MsgPickerDelegate extends Ui.PickerDelegate {

	function onAccept(values) {
        Sys.println("Antonio - onAcceptR");
		for(var i = 0; i < values.size(); i++) { msg = values[i]; Sys.println(msg); }
		Sys.println("Antonio - To: " + name + "; Msg: " + msg);
		Comm.makeWebRequest("http://sms_test", {}, {}, method(:onSMSReceive));
		Ui.popView(Ui.SLIDE_DOWN);
		return true;
	}
	
	function onCancel() {
        Sys.println("Antonio - onCancelR");
		Ui.popView(Ui.SLIDE_DOWN);
		return true;
	}
	
    function onSMSReceive(responseCode, data) {
        Sys.println("Antonio - onSMSReceive");
        if (responseCode == 200) {
        	Sys.println("Stock response data: " + data);
        }
    }	
}

//////////////////////////
// Generate WordFactory
//////////////////////////
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
