package cn.iocoder.aios.module.mes.dal.mysql.wm.salesnotice;

import cn.iocoder.aios.framework.common.pojo.PageResult;
import cn.iocoder.aios.framework.mybatis.core.mapper.BaseMapperX;
import cn.iocoder.aios.framework.mybatis.core.query.LambdaQueryWrapperX;
import cn.iocoder.aios.module.mes.controller.admin.wm.salesnotice.vo.line.MesWmSalesNoticeLinePageReqVO;
import cn.iocoder.aios.module.mes.dal.dataobject.wm.salesnotice.MesWmSalesNoticeLineDO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * MES 发货通知单行 Mapper
 */
@Mapper
public interface MesWmSalesNoticeLineMapper extends BaseMapperX<MesWmSalesNoticeLineDO> {

    default PageResult<MesWmSalesNoticeLineDO> selectPage(MesWmSalesNoticeLinePageReqVO reqVO) {
        return selectPage(reqVO, new LambdaQueryWrapperX<MesWmSalesNoticeLineDO>()
                .eqIfPresent(MesWmSalesNoticeLineDO::getNoticeId, reqVO.getNoticeId())
                .orderByDesc(MesWmSalesNoticeLineDO::getId));
    }

    default List<MesWmSalesNoticeLineDO> selectListByNoticeId(Long noticeId) {
        return selectList(MesWmSalesNoticeLineDO::getNoticeId, noticeId);
    }

    default void deleteByNoticeId(Long noticeId) {
        delete(MesWmSalesNoticeLineDO::getNoticeId, noticeId);
    }

}
