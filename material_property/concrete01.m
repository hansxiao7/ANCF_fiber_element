%This model is to build the concrete constitutive eqn for modified Kent and
%Park model
function c = concrete01(strain, strain_history, stress_history, fc, strain_0, Z,...
    strain_u, strain_r, strain_p)
%fc, strain_0, strain_r, strain_u are all negative, like OpenSees
if strain<strain_u
    strain
    error('Concrete fails!!!');
end


if strain > strain_p
    c.stress = 0;
    c.E = 0;
    c.strain_r = strain_r;
    c.strain_p = strain_p;
else
    if strain_history(1) == 0 && strain_history(2) ==0 && strain_r == 0%initialization
        flag = 1;
        if abs(strain) <= abs(strain_0)
            c.stress = fc * (2*strain/strain_0-(strain/strain_0)^2) ;
            c.E = TangentModulusConcBackbone1(fc, strain, strain_0);
        else
            c.stress = fc * (1- Z * (abs(strain) - abs(strain_0)));
            c.E = TangentModulusConcBackbone2(Z,fc,strain);
            if abs(c.stress) < 0.2*abs(fc)
                c.stress = 0.2 * fc;
                c.E = 0;
            end
        end
        c.strain_r = strain_r;
        c.strain_p = strain_p;
    else
        if strain_r == 0 %never unloaded, or on the backbone
            if (strain_history(2)-strain_history(1)) * (strain - strain_history(2)) < 0 %unloading happens
                flag = 2;
                c.strain_r = strain_history(2);
                if c.strain_r/strain_0 < 2
                    c.strain_p = strain_0 * (0.145*(c.strain_r/strain_0)^2+ 0.13*(c.strain_r / strain_0));
                else
                    c.strain_p = strain_0 * (0.707*(c.strain_r/strain_0-2)+0.834);
                end
                
%                 if c.strain_p > 0
%                     c.strain_p = 0;
%                 end
                
                c.E = stress_history(2) / (c.strain_r - c.strain_p);
                c.stress = stress_history(2) + c.E * (strain - c.strain_r);
            elseif (strain_history(2)-strain_history(1)) == 0 && (strain - strain_history(2)) >0 %unloading
                flag = 2;
                c.strain_r = strain_history(2);
                if c.strain_r/strain_0 < 2
                    c.strain_p = strain_0 * (0.145*(c.strain_r/strain_0)^2+ 0.13*(c.strain_r / strain_0));
                else
                    c.strain_p = strain_0 * (0.707*(c.strain_r/strain_0-2)+0.834);
                end
                
%                 if c.strain_p > 0
%                     c.strain_p = 0;
%                 end
                
                c.E = stress_history(2) / (c.strain_r - c.strain_p);
                c.stress = stress_history(2) + c.E * (strain - c.strain_r);
            else
                flag = 1;
                if abs(strain) <= abs(strain_0)
                    c.stress = fc * (2*strain/strain_0-(strain/strain_0)^2) ;
                  
                    c.E = TangentModulusConcBackbone1(fc, strain, strain_0);
                else
                    c.stress = fc * (1- Z * (abs(strain) - abs(strain_0)));
                    c.E = TangentModulusConcBackbone2(Z,fc,strain);
                    if abs(c.stress) < 0.2*abs(fc)
                        c.stress = 0.2 * fc;
                        c.E = 0;
                    end
                end
                c.strain_r = strain_r;
                c.strain_p = strain_p;
            end
        else
            if abs(strain)<=abs(strain_r) %on the straight line 
                if abs(strain_r) <= abs(strain_0)
                    stress_r = fc * (2*strain_r/strain_0-(strain_r/strain_0)^2) ;
                else
                    stress_r = fc * (1- Z * (abs(strain_r) - abs(strain_0)));
                    if abs(stress_r) < 0.2*abs(fc)
                        stress_r = 0.2 * fc;
                    end
                end
                c.E = (stress_r) / (strain_r - strain_p);
                c.stress = c.E*(strain - strain_p);
                c.strain_r = strain_r;
                c.strain_p = strain_p;
            else
                if abs(strain) <= abs(strain_0)
                    c.stress = fc * (2*strain/strain_0-(strain/strain_0)^2) ;
                    c.E = TangentModulusConcBackbone1(fc, strain, strain_0);
                else
                    c.stress = fc * (1- Z * (abs(strain) - abs(strain_0)));
                    c.E = TangentModulusConcBackbone2(Z,fc,strain);
                    if abs(c.stress) < 0.2*abs(fc)
                        c.stress = 0.2 * fc;
                        c.E = 0;
                    end
                end
                c.strain_r = 0;
                c.strain_p = 0;
            end
        end
    end
end

if strain > c.strain_p
    c.stress = 0;
    c.E = 0;
end
c.fc = fc;
c.strain_0 = strain_0;
c.Z = Z;
c.strain_u = strain_u;
c.strain_history = [strain_history(2), strain];
c.stress_history = [stress_history(2), c.stress];
end