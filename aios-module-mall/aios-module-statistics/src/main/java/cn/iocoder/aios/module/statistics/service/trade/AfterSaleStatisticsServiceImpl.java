package cn.iocoder.aios.module.statistics.service.trade;

import cn.iocoder.aios.module.statistics.dal.mysql.trade.AfterSaleStatisticsMapper;
import cn.iocoder.aios.module.statistics.service.trade.bo.AfterSaleSummaryRespBO;
import cn.iocoder.aios.module.trade.enums.aftersale.AfterSaleStatusEnum;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import javax.annotation.Resource;
import java.time.LocalDateTime;

/**
 * 售后统计 Service 实现类
 *
 * @author owen
 */
@Service
@Validated
public class AfterSaleStatisticsServiceImpl implements AfterSaleStatisticsService {

    @Resource
    private AfterSaleStatisticsMapper afterSaleStatisticsMapper;

    @Override
    public AfterSaleSummaryRespBO getAfterSaleSummary(LocalDateTime beginTime, LocalDateTime endTime) {
        return afterSaleStatisticsMapper.selectSummaryByRefundTimeBetween(beginTime, endTime);
    }

    @Override
    public Long getCountByStatus(AfterSaleStatusEnum status) {
        return afterSaleStatisticsMapper.selectCountByStatus(status.getStatus());
    }

}
