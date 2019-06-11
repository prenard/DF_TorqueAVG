using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;

class DF_TorqueAVGView extends Ui.DataField
{

	//var App_Title;
	//var App_Version;

	var DF_Title_Text = "";
	var DF_Title_x = 0;
	var DF_Title_y = 0;
	var DF_Title_font = Gfx.FONT_XTINY;

	var Torque_Value = 0;
	var Torque_Value_x = 0;
	var Torque_Value_y = 0;
	var Torque_Value_font = Gfx.FONT_XTINY;

	var Torque_Unit = "Nm";
	var Torque_Unit_x = 0;
	var Torque_Unit_y = 0;
	var Torque_Unit_font = Gfx.FONT_XTINY;


    var power, cadence, torque;
    
    var duration;
    
    // array of torque values in each second of the past N seconds
    var history_torque;
    // location for next insert into `history' array
	var next_sample_idx;
	// sum of the torque in the past N seconds
	var sum_of_samples;
	// number of seconds for which we have data in `history'
	var number_of_samples;

    //! Set the label of the data field here.
    function initialize(Args)
    {
		System.println("View - Initialize / Start - Used Memory = " + System.getSystemStats().usedMemory);
        DataField.initialize();

        duration = Args[0];

   	    DF_Title_Text = "Torque AVG " + duration + "s";
		
        history_torque = new[duration];
		
		//System.println("AVG duration = " + history_torque.size());
		
		next_sample_idx = 0;
		sum_of_samples = 0;
		number_of_samples = 0;
        
        for (var i = 0; i < history_torque.size(); ++i)
        	{
				history_torque [i] = 0;
			}

        //TorqueField = new WatchUi.Drawable({:identifier=>"TorqueField"});

    }

    //! The given info object contains all the current workout
    //! information. Calculate a value and return it in this method.
    function compute(info)
    {

            if( (info.currentPower != null) and (info.currentCadence != null) )
            {

				power = info.currentPower.toFloat();
				cadence = info.currentCadence ;

				torque = 0;
				if (info.currentCadence > 0)
				{
					torque = power / cadence / 2 / Math.PI * 60;
				}

				// subtract the oldest sample from our moving sum
				sum_of_samples -= history_torque [next_sample_idx];

				// calculate the distance traveled since the last call
				history_torque [next_sample_idx] = torque;

				// add the newest sample to our moving sum
				sum_of_samples += history_torque [next_sample_idx];

				// keep track of how many samples we've accrued
				if (number_of_samples < history_torque.size())
				{
					++number_of_samples;
				}

				Torque_Value =  (sum_of_samples / number_of_samples).format("%.2f");

				System.println("Torque_Value = " + Torque_Value);				
				
				// advance to the next sample, and wrap around to the beginning
				next_sample_idx = (next_sample_idx + 1) % history_torque.size();
			}
     }

    function onLayout(dc)
    {
		System.println("View - onLayout / Start - Used Memory = " + System.getSystemStats().usedMemory);

    	System.println("DC Height  = " + dc.getHeight());
      	System.println("DC Width  = " + dc.getWidth());

    	//! The given info object contains all the current workout
    	//! information. Calculate a value and return it in this method.

		var Font = new [4];

		Font[0] = Gfx.FONT_NUMBER_MILD;
		Font[1] = Gfx.FONT_NUMBER_MEDIUM;		
		Font[2] = Gfx.FONT_NUMBER_HOT;
		Font[3] = Gfx.FONT_NUMBER_THAI_HOT;

		var Value_Pattern = "";
		
		Value_Pattern = "888.8";

   		for (var i = Font.size() - 1; i >= 0 ; --i)
   		{
			System.println("i = " + i);
   			Torque_Value_font = Font[i];

			if (
				(Gfx.getFontHeight(Torque_Value_font) <= dc.getHeight() - Gfx.getFontHeight(DF_Title_font) - 5)
				&
				(dc.getTextWidthInPixels(Value_Pattern, Torque_Value_font) <= dc.getWidth() - dc.getTextWidthInPixels(Torque_Unit, Torque_Unit_font) - 6)
			   )
			{
				System.println("Torque_Value - Font = " + i);
				break;
			}
   		}


		Torque_Value_x = dc.getTextWidthInPixels(Value_Pattern, Torque_Value_font) ;
		Torque_Value_y = Gfx.getFontHeight(DF_Title_font);

		System.println("Torque_Value_x = " + Torque_Value_x);
		System.println("Torque_Value_y = " + Torque_Value_y);
		
	   	View.setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onUpdate(dc)
    {
		//System.println("View - onUpdate / Start - Used Memory = " + System.getSystemStats().usedMemory);
		
        // Set the background color
        View.findDrawableById("Background").setColor(getBackgroundColor());
	
		var FontDisplayColor = Gfx.COLOR_BLACK;
        
        if (getBackgroundColor() == Gfx.COLOR_BLACK)
        {
            FontDisplayColor = Gfx.COLOR_WHITE;
        }
        else
        {
            FontDisplayColor = Gfx.COLOR_BLACK;
        }
		
        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);

		textL(dc, DF_Title_x, DF_Title_y, DF_Title_font, FontDisplayColor, DF_Title_Text);
		textR(dc, Torque_Value_x, Torque_Value_y, Torque_Value_font, FontDisplayColor, Torque_Value.toString());
	}

	function textR(dc, x, y, font, color, s)
	{
		if (s != null)
		{
			dc.setColor(color, Gfx.COLOR_TRANSPARENT);
			//dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_RIGHT|Graphics.TEXT_JUSTIFY_VCENTER);
			dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_RIGHT);
		}
	}

	function textL(dc, x, y, font, color, s)
	{
		if (s != null)
		{
			dc.setColor(color, Gfx.COLOR_TRANSPARENT);
			//dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
			dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_LEFT);
		}
	}

}