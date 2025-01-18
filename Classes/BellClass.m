classdef BellClass < handle
    properties
        SampleRate
        State = false;              %True = off - False = On
        CenterFreq
        CenterFreqNormalized
        Gain
        QFactor
        Bandwidth
        BandwidthNormalized
        Slope
        Numerator     
        Denominator   
    end
    
    methods
        function obj = BellClass(SampleRate, CenterFreq, Gain, QFactor, selectedSlope)
            obj.SampleRate = SampleRate;
            obj.CenterFreq = CenterFreq;
            obj.Gain = Gain;
            obj.QFactor = QFactor;  
            
            %Compute Derived Parameters
            obj.CenterFreqNormalized = CenterFreq/(SampleRate/2);
            obj.Bandwidth = CenterFreq/QFactor;
            obj.BandwidthNormalized = obj.Bandwidth/(SampleRate/2);
            
            obj.setSlope(selectedSlope);
        end
        
        function designBell(obj)
            [obj.Numerator, obj.Denominator] = designParamEQ(obj.Slope, obj.Gain, obj.CenterFreqNormalized, obj.BandwidthNormalized, Orientation="row");
        end
        function setSlope(obj, selectedSlope)
            switch selectedSlope.Text
                case '12 dB/oct'
                    obj.Slope = 2;  
                case '24 dB/oct'
                    obj.Slope = 4;  
                case '36 dB/oct'
                    obj.Slope = 6;  
            end
            obj.designBell();
        end
        function setCenterFreq(obj, CenterFreq)
            obj.CenterFreq = CenterFreq;
            obj.CenterFreqNormalized = CenterFreq/(obj.SampleRate/2);
            obj.Bandwidth = obj.CenterFreq/obj.QFactor;
            obj.BandwidthNormalized = obj.Bandwidth/(obj.SampleRate/2); 
            obj.designBell();
        end
        function setQFactor(obj, QFactor)
            obj.QFactor = QFactor;
            obj.Bandwidth = obj.CenterFreq/QFactor;
            obj.BandwidthNormalized = obj.Bandwidth/(obj.SampleRate/2);          
            obj.designBell();
        end
        function setGain(obj, Gain)
            obj.Gain = Gain;
            obj.designBell();
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
        function [B, A] = getBypassFilter(obj)
            [B, A] = designParamEQ(obj.Slope, 0, obj.CenterFreqNormalized, obj.BandwidthNormalized, Orientation="row");
        end
    end
end

