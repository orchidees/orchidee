function attribute = get_attribute(filter_instance)

% GET_ATTRIBUTE - Return the name of the filtered field. It is generally an
% attribute, but it can be any queryable field.
%
% Usage: attribute = get_attribute(filter_instance)
%

attribute = filter_instance.attribute;