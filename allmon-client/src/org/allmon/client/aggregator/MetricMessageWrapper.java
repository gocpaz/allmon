package org.allmon.client.aggregator;

import java.util.ArrayList;
import java.util.Iterator;

import org.allmon.common.MetricMessage;

public class MetricMessageWrapper {

    private ArrayList list = new ArrayList(); // TODO check in allmon-client would be compilable in 1.5 to introduce generics

    public boolean add(MetricMessage o) {
        return list.add(o);
    }

    public boolean add(MetricMessageWrapper o) {
        if (o != null) {
            return list.addAll(o.list);
        } else {
            return false;
        }   
    }
    
    public void clear() {
        list.clear();
    }

    public boolean contains(MetricMessage elem) {
        return list.contains(elem);
    }

    public MetricMessage get(int index) {
        return (MetricMessage)list.get(index);
    }

    public int indexOf(MetricMessage elem) {
        return list.indexOf(elem);
    }

    public Iterator iterator() {
        return list.iterator();
    }

    public Object remove(int index) {
        return list.remove(index);
    }

    public boolean remove(MetricMessage o) {
        return list.remove(o);
    }

    public MetricMessage set(int index, Object element) {
        return (MetricMessage)list.set(index, element);
    }

    public int size() {
        return list.size();
    }

    public Object[] toArray() {
        return list.toArray();
    }

    public String toString() {
        return list.toString();
    }
    
    
    
}
