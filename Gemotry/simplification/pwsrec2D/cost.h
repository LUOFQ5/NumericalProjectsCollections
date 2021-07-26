#ifndef _COST_H_
#define _COST_H_

#undef min
#undef max

template <class FT>
class CCost
{
private:
    FT m_norm;
    FT m_tang;
    FT m_max_norm;
    FT m_max_tang;
    
public:
    CCost()
    {
        m_norm = 0.0;
        m_tang = 0.0; 
        m_max_norm = 0.0;
        m_max_tang = 0.0;
    }
    
    CCost(const FT norm, const FT tang)
    {
        m_norm = norm;
        m_tang = tang;
        m_max_norm = norm;
        m_max_tang = tang;
    }
    
    ~CCost() { }
    
    CCost& operator = (const CCost& cost)
    {
        m_norm = cost.norm();
        m_tang = cost.tang();
        m_max_norm = cost.max_norm();
        m_max_tang = cost.max_tang();
        return *this;
    }
    
    const FT norm() const { return m_norm; }
    
    const FT tang() const { return m_tang; }

    const FT max_norm() const { return m_max_norm; }

    const FT max_tang() const { return m_max_tang; }

    FT finalize(const FT alpha = 0.5) const 
    { 
        return 2.0 * (alpha * m_norm + (1.0 - alpha) * m_tang);
    }
    
    void divide(const FT ratio)
    {
        assert(ratio != 0.0);
        m_norm /= ratio;
        m_tang /= ratio;
    }
    
    void add(const CCost& cost, const FT mass = 1.0)
    {
        m_norm += mass * cost.norm();
        m_tang += mass * cost.tang();
    }
    
    void reset_max()
    {
        m_max_norm = 0.0;
        m_max_tang = 0.0;
    }

    void update_max(const CCost& cost)
    {
        m_max_norm = std::max(m_max_norm, cost.max_norm());
        m_max_tang = std::max(m_max_tang, cost.max_tang());
    }

    void compute_max(const FT norm, const FT tang)
    {
        m_max_norm = std::max(m_max_norm, norm);
        m_max_tang = std::max(m_max_tang, tang);
    }
};

#endif
