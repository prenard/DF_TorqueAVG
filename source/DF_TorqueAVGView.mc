using Toybox.WatchUi as Ui;

class DF_TorqueAVGView extends Ui.SimpleDataField
{

	var App_Title;
	var App_Version;

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
    function initialize(D,T,V)
    {
        SimpleDataField.initialize();

		App_Title = T;
		App_Version = V;
        duration = D;

        label = "Torque AVG " + duration + "s";
		
        history_torque = new[duration];
		
		//System.println("AVG duration = " + history_torque.size());
		
		next_sample_idx = 0;
		sum_of_samples = 0;
		number_of_samples = 0;
        
        for (var i = 0; i < history_torque.size(); ++i)
        	{
				history_torque [i] = 0;
			}

    }

    //! The given info object contains all the current workout
    //! information. Calculate a value and return it in this method.
    function compute(info)
    {
            var value_picked = null;

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

				//value_picked =  (sum_of_samples / number_of_samples).format("%06.2f");
				value_picked =  (sum_of_samples / number_of_samples).format("%.2f");
				if (value_picked == 0)
					{
						value_picked = null;
					}
					else
					{
						//value_picked = value_picked + " N-m";
					}

				//System.println("avg = " + value_picked.format("%.2f"));
				
				// advance to the next sample, and wrap around to the beginning
				next_sample_idx = (next_sample_idx + 1) % history_torque.size();
			}
        return value_picked;
     }

}