function y_scaled=featureScale(y)

y_scaled = (y-min(y))/(max(y)-min(y));

end


