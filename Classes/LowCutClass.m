classdef LowCutClass < handle
    properties
        SampleRate
        State = false;              %True = off - False = On
        CutOffFreq
        CutOffFreqNormalized
        Slope
        Numerator
        Denominator
    end
    methods
        function obj = LowCutClass(SampleRate, CutOffFreq, selectedSlope)
            obj.SampleRate = SampleRate;
            obj.CutOffFreq = CutOffFreq;
            obj.CutOffFreqNormalized = CutOffFreq/(SampleRate/2);
            
            obj.setSlope(selectedSlope);
        end
        function designHP(obj)
            [obj.Numerator, obj.Denominator] = designVarSlopeFilter(obj.Slope, obj.CutOffFreqNormalized,"hi", "Orientation","row");
        end
        function setSlope(obj, selectedSlope)
            switch selectedSlope.Text
                case '6 dB/oct'
                    obj.Slope = 6;
                case '12 dB/oct'
                    obj.Slope = 12;
                case '18 dB/oct'
                    obj.Slope = 18;
            end
            obj.designHP();
        end
        function setCutOffFreq(obj, CutOffFreq)
            obj.CutOffFreq = CutOffFreq;
            obj.CutOffFreqNormalized = CutOffFreq/(obj.SampleRate/2);
            obj.designHP();
        end
        function on(obj)
            obj.State = true;
        end
        function off(obj)
            obj.State = false;
        end
        function State = getState(obj)
            State = obj.State;
        end
    end
end
